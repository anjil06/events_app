import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/cloudinary_upload_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../events/data/services/event_services.dart';
import '../../../events/domain/models/event_model.dart';
import '../../../notifications/data/services/notification_service.dart';

class EventFormScreen extends StatefulWidget {
const EventFormScreen({super.key, this.event});
  final EventModel? event;

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _location;
  late final TextEditingController _time;

  String _imageUrl = '';
  String? _imagePublicId;
  Uint8List? _previewImageBytes;
  bool _isUploadingImage = false;
  String? _uploadError;

  String _category = 'Workshops';
  String _domain = 'Programming';
  String _level = 'Beginner';
  bool _isOnline = false;
  DateTime? _date;
  DateTime? _deadline;
  bool _isSaving = false;

static const _categories = ['Hackathons', 'Coding', 'Workshops', 'Webinars', 'Meetups'];
static const _domains = ['Web Development', 'App Development', 'AI & ML', 'Data Science', 'Cyber Security', 'Cloud Computing', 'Blockchain', 'IoT', 'Programming'];
static const _levels = ['Beginner', 'Advanced'];

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    _title = TextEditingController(text: event?.title ?? '');
    _description = TextEditingController(text: event?.description ?? '');
    _location = TextEditingController(text: event?.location ?? '');
    _time = TextEditingController(text: event?.time ?? '');
    _imageUrl = event?.imageUrl ?? '';
    _imagePublicId = event?.imagePublicId;
    _category = event?.category ?? _category;
    _domain = event?.domain ?? _domain;
    _level = event?.level ?? _level;
    _isOnline = event?.isOnline ?? false;
    _date = event?.date;
    _deadline = event?.registrationDeadline;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _location.dispose();
    _time.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool deadline}) async {
    final selected = await showDatePicker(
      context: context,
initialDate: (deadline ? _deadline : _date) ?? DateTime.now(),
firstDate: DateTime.now(),
lastDate: DateTime.now().add(const Duration(days: 1095)),
    );
if (selected != null && mounted) {
      setState(() {
if (deadline) {
          _deadline = selected;
        } else {
          _date = selected;
        }
      });
    }
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
maxWidth: 1920,
maxHeight: 1080,
imageQuality: 85,
      );

if (pickedFile == null) return;

      final bytes = await pickedFile.readAsBytes();

      setState(() {
        _previewImageBytes = bytes;
        _isUploadingImage = true;
        _uploadError = null;
      });

      final result = await CloudinaryUploadService.instance.uploadEventImage(
        pickedFile,
oldPublicId: _imagePublicId,
      );

if (!mounted) return;

      setState(() {
        _imageUrl = result.secureUrl;
        _imagePublicId = result.publicId;
        _isUploadingImage = false;
      });

      _message('Banner uploaded to Cloudinary successfully.');
    } catch (e) {
if (!mounted) return;
      setState(() {
        _isUploadingImage = false;
        _uploadError = e.toString().replaceAll('Exception: ', '');
      });
      _message('Upload failed: $_uploadError');
    }
  }

  void _removeImage() {
if (_imagePublicId != null && _imagePublicId!.isNotEmpty) {
      CloudinaryUploadService.instance.deleteImage(_imagePublicId!);
    }

    setState(() {
      _imageUrl = '';
      _imagePublicId = null;
      _previewImageBytes = null;
      _uploadError = null;
    });
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
child: Column(
            mainAxisSize: MainAxisSize.min,
children: [
              Container(
                height: 4,
width: 40,
decoration: BoxDecoration(
                  color: Colors.grey.shade300,
borderRadius: BorderRadius.circular(2),
                ),
              ),
const SizedBox(height: 16),
const Text(
                'Select Event Banner Image',
style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
const SizedBox(height: 16),
ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
decoration: BoxDecoration(
                    color: AppTheme.lightOrange,
borderRadius: BorderRadius.circular(12),
                  ),
child: const Icon(Icons.photo_camera_rounded, color: AppTheme.primaryOrange),
                ),
title: const Text('Take Photo', style: TextStyle(fontWeight: FontWeight.w600)),
subtitle: const Text('Capture using device camera'),
onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadImage(ImageSource.camera);
                },
              ),
ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
decoration: BoxDecoration(
                    color: AppTheme.lightOrange,
borderRadius: BorderRadius.circular(12),
                  ),
child: const Icon(Icons.photo_library_rounded, color: AppTheme.primaryOrange),
                ),
title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
subtitle: const Text('Select from photos or files'),
onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    final hasImage = _previewImageBytes != null || _imageUrl.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
            const Text(
              'Event Banner Image',
style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
Row(
              children: [
                const Icon(Icons.cloud_done_rounded, size: 14, color: AppTheme.primaryOrange),
const SizedBox(width: 4),
Text(
                  'Cloudinary Storage',
style: TextStyle(
                    fontSize: 11,
fontWeight: FontWeight.w600,
color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
const SizedBox(height: 8),
InkWell(
          borderRadius: BorderRadius.circular(18),
onTap: _isUploadingImage ? null : _showImageSourceDialog,
child: Container(
            height: 180,
width: double.infinity,
decoration: BoxDecoration(
              color: Colors.white,
borderRadius: BorderRadius.circular(18),
border: Border.all(
                color: hasImage ? AppTheme.primaryOrange.withValues(alpha: 0.3) : Colors.grey.shade300,
width: hasImage ? 1.5 : 1,
              ),
boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
blurRadius: 10,
offset: const Offset(0, 4),
                ),
              ],
            ),
clipBehavior: Clip.antiAlias,
child: Stack(
              children: [
                Positioned.fill(
                  child: hasImage
? (_previewImageBytes != null
? Image.memory(
                              _previewImageBytes!,
fit: BoxFit.cover,
                            )
: Image.network(
                              _imageUrl,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) => Container(
                                color: AppTheme.lightOrange,
child: const Center(
                                  child: Icon(Icons.broken_image_rounded, size: 48, color: AppTheme.primaryOrange),
                                ),
                              ),
                            ))
: Container(
                          color: AppTheme.lightOrange.withValues(alpha: 0.3),
child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
children: [
                              Container(
                                padding: const EdgeInsets.all(14),
decoration: const BoxDecoration(
                                  color: AppTheme.lightOrange,
shape: BoxShape.circle,
                                ),
child: const Icon(
                                  Icons.add_photo_alternate_rounded,
size: 32,
color: AppTheme.primaryOrange,
                                ),
                              ),
const SizedBox(height: 10),
const Text(
                                'Tap to upload event image',
style: TextStyle(
                                  fontSize: 14,
fontWeight: FontWeight.w700,
color: Colors.black87,
                                ),
                              ),
const SizedBox(height: 4),
Text(
                                'PNG, JPG, WEBP up to 10MB',
style: TextStyle(
                                  fontSize: 12,
color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),

                // Uploading progress overlay
if (_isUploadingImage)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.6),
child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
children: const[
                          CircularProgressIndicator(
                            color: Colors.white,
strokeWidth: 3,
                          ),
SizedBox(height: 14),
Text(
                            'Uploading to Cloudinary...',
style: TextStyle(
                              color: Colors.white,
fontSize: 13,
fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Actions bar when image exists
if (hasImage && !_isUploadingImage)
                  Positioned(
                    bottom: 10,
right: 10,
child: Row(
                      mainAxisSize: MainAxisSize.min,
children: [
                        Material(
                          color: Colors.black.withValues(alpha: 0.7),
borderRadius: BorderRadius.circular(10),
child: InkWell(
                            borderRadius: BorderRadius.circular(10),
onTap: _showImageSourceDialog,
child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
child: Row(
                                children: [
                                  Icon(Icons.edit_rounded, size: 14, color: Colors.white),
SizedBox(width: 4),
Text(
                                    'Change',
style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
const SizedBox(width: 8),
Material(
                          color: Colors.red.withValues(alpha: 0.85),
borderRadius: BorderRadius.circular(10),
child: InkWell(
                            borderRadius: BorderRadius.circular(10),
onTap: _removeImage,
child: const Padding(
                              padding: EdgeInsets.all(6),
child: Icon(Icons.delete_outline_rounded, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
if (_uploadError != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
child: Text(
              _uploadError!,
style: TextStyle(color: Colors.red.shade700, fontSize: 12),
            ),
          ),
const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _save() async {
if (_isUploadingImage) {
      _message('Please wait for the banner image to finish uploading to Cloudinary.');
      return;
    }
if (!_formKey.currentState!.validate() || _date == null || _deadline == null) {
if (_date == null || _deadline == null) _message('Select the event date and registration deadline.');
      return;
    }
if (_deadline!.isAfter(_date!)) {
      _message('Registration deadline must be on or before the event date.');
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
if (user == null) {
      _message('Please sign in to publish events.');
      return;
    }
    setState(() => _isSaving = true);
    final existing = widget.event;
    final event = EventModel(
      id: existing?.id ?? '',
title: _title.text.trim(),
description: _description.text.trim(),
category: _category,
domain: _domain,
organizerId: existing?.organizerId ?? user.uid,
organizerName: existing?.organizerName ?? (user.displayName?.trim().isNotEmpty == true ? user.displayName!.trim() : user.email ?? 'TechCulture organizer'),
date: _date!, time: _time.text.trim(), location: _location.text.trim(), isOnline: _isOnline,
level: _level, registrationDeadline: _deadline!,
imageUrl: _imageUrl,
imagePublicId: _imagePublicId,
createdAt: existing?.createdAt,
    );
    try {
if (existing == null) {
        final newId = await EventService.instance.createEvent(event);
        await NotificationService.instance.notifyEventPublished(
          organizerId: user.uid,
event: event.copyWith(id: newId),
        );
      } else {
        await EventService.instance.updateEvent(event);
      }
if (mounted) {
        _message(existing == null ? 'Event published.' : 'Event updated.');
        Navigator.pop(context);
      }
    } catch (_) {
      _message('Unable to save the event. Please try again.');
    } finally {
if (mounted) setState(() => _isSaving = false);
    }
  }

  void _message(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  String _dateLabel(DateTime? value, String empty) => value == null ? empty : '${value.day}/${value.month}/${value.year}';
  String? _required(String? value) => value == null || value.trim().isEmpty ? 'This field is required' : null;

  @override
  Widget build(BuildContext context) {
    final editing = widget.event != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit Event' : 'Create Event')),
body: Form(
        key: _formKey,
child: ListView(
          padding: const EdgeInsets.all(20),
children: [
            Text(editing ? 'Update your event details.' : 'Publish an event for the TechCulture community.', style: TextStyle(color: Colors.grey.shade700)),
const SizedBox(height: 20),
_buildImagePicker(),
_field(_title, 'Event title', 'e.g. Flutter Workshop 2026'),
_field(_description, 'Description', 'Tell attendees what to expect', lines: 5),
_dropdown('Category', _category, _categories, (value) => setState(() => _category = value!)),
_dropdown('Domain', _domain, _domains, (value) => setState(() => _domain = value!)),
_dropdown('Experience level', _level, _levels, (value) => setState(() => _level = value!)),
SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Online event'), value: _isOnline, activeThumbColor: AppTheme.primaryOrange, onChanged: (value) => setState(() => _isOnline = value)),
_field(_location, _isOnline ? 'Meeting link or platform' : 'Venue / location', _isOnline ? 'e.g. Google Meet' : 'e.g. Main auditorium'),
_field(_time, 'Time', 'e.g. 10:00 AM - 1:00 PM'),
ListTile(contentPadding: EdgeInsets.zero, title: const Text('Event date'), subtitle: Text(_dateLabel(_date, 'Select a date')), trailing: const Icon(Icons.calendar_month_rounded), onTap: () => _pickDate(deadline: false)),
ListTile(contentPadding: EdgeInsets.zero, title: const Text('Registration deadline'), subtitle: Text(_dateLabel(_deadline, 'Select a date')), trailing: const Icon(Icons.event_available_rounded), onTap: () => _pickDate(deadline: true)),
const SizedBox(height: 16),
ElevatedButton(onPressed: _isSaving ? null : _save, child: _isSaving ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text(editing ? 'Save Changes' : 'Publish Event')),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label, String hint, {int lines = 1, bool required = true}) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
child: TextFormField(controller: controller, validator: required ? _required : null, maxLines: lines, decoration: InputDecoration(labelText: label, hintText: hint)),
  );

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
child: DropdownButtonFormField<String>(initialValue: value, decoration: InputDecoration(labelText: label), items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(), onChanged: onChanged),
  );
}