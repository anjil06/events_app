import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/cloudinary_upload_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
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

  String _category = 'College Fest';
  String _domain = 'Inter-College Fest';
  String _level = 'All Levels';
  bool _isOnline = false;
  DateTime? _date;
  DateTime? _deadline;
  bool _isSaving = false;

static const _categories = [
    'College Fest',
'Technical Fest / Hackathon',
'Cultural Fest',
'Coding & Development',
'Dance & Choreography',
'Music & Singing',
'Drama & Theatre',
'Fashion Show',
'Robotics & IoT',
'Fine Arts & Photography',
'Literary & Debating',
'Concert & Pro-Night',
'Gaming & Esports',
'Workshops & Seminars',
  ];
static const _domains = [
    'Inter-College Fest',
'Hackathon & Ideathon',
'Competitive Coding',
'Web & App Development',
'AI & Machine Learning',
'Cloud & Cyber Security',
'Robotics & Embedded',
'Solo / Group Dance',
'Battle of the Bands',
'Classical & Vocals',
'Street Play (Nukkad)',
'Stage Play & Skit',
'Runway & Fashion Walk',
'Painting & Sketching',
'Photography & Film',
'Debate & Quiz',
'Stand-up & Poetry',
'EDM & DJ Night',
'Esports Championship',
'Campus Carnival',
  ];
static const _levels = ['All Levels', 'Beginner', 'Intermediate', 'Advanced'];

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
if (event != null) {
      _category = _categories.contains(event.category) ? event.category : _categories.first;
      _domain = _domains.contains(event.domain) ? event.domain : _domains.first;
      _level = _levels.contains(event.level) ? event.level : _levels.first;
    }
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
      backgroundColor: Colors.grey.shade50,
appBar: AppBar(
        title: Text(editing ? 'Edit Event' : 'Create Event'),
backgroundColor: Colors.white,
elevation: 0,
      ),
body: Form(
        key: _formKey,
child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
children: [
            Text(
              editing ? 'Update your event details' : 'Publish an event 🚀',
style: const TextStyle(
                fontSize: 26,
fontWeight: FontWeight.w800,
color: Colors.black,
              ),
            ),
const SizedBox(height: 6),
Text(
              editing
? 'Keep the community updated with the latest event info.'
: 'Share technical hackathons, coding workshops, college fests, and cultural competitions with the TechCulture community.',
style: TextStyle(
                fontSize: 14,
color: Colors.grey.shade600,
height: 1.4,
              ),
            ),
const SizedBox(height: 24),

            // Card 1: Banner Image
_buildCardWrapper(
              title: 'Event Banner',
subtitle: 'Upload a banner or thumbnail for your event',
child: _buildImagePicker(),
            ),
const SizedBox(height: 20),

            // Card 2: Basic Information
_buildCardWrapper(
              title: 'Basic Details',
subtitle: 'Event title, summary, category and domain',
child: Column(
                children: [
                  _field(_title, 'Event title', 'e.g. Tarang 2026 - Annual Cultural Fest', icon: Icons.title_rounded),
_field(_description, 'Description', 'Tell attendees what to expect...', lines: 4, icon: Icons.description_outlined),
_dropdown('Category', _category, _categories, Icons.category_outlined, (value) => setState(() => _category = value!)),
_dropdown('Domain', _domain, _domains, Icons.domain_rounded, (value) => setState(() => _domain = value!)),
_dropdown('Experience level', _level, _levels, Icons.trending_up_rounded, (value) => setState(() => _level = value!)),
                ],
              ),
            ),
const SizedBox(height: 20),

            // Card 3: Date, Venue & Timing
_buildCardWrapper(
              title: 'Date & Location',
subtitle: 'Set schedule and physical/virtual location',
child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
decoration: BoxDecoration(
                      color: Colors.white,
borderRadius: BorderRadius.circular(14),
border: Border.all(color: Colors.grey.shade300, width: 1.2),
                    ),
child: SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
title: const Text(
                        'Online Event',
style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
subtitle: Text(
                        _isOnline ? 'Virtual event via meeting link' : 'In-person event at physical venue',
style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
secondary: Icon(
                        _isOnline ? Icons.videocam_rounded : Icons.location_on_rounded,
color: AppTheme.primaryOrange,
                      ),
value: _isOnline,
activeThumbColor: AppTheme.primaryOrange,
onChanged: (value) => setState(() => _isOnline = value),
                    ),
                  ),
_field(
                    _location,
_isOnline ? 'Meeting link or platform' : 'Venue / location',
_isOnline ? 'e.g. Google Meet, Zoom' : 'e.g. Main Auditorium, Campus Hall',
icon: _isOnline ? Icons.link_rounded : Icons.place_outlined,
                  ),
_field(
                    _time,
'Time',
'e.g. 10:00 AM - 1:00 PM',
icon: Icons.schedule_rounded,
                  ),
Padding(
                    padding: const EdgeInsets.only(bottom: 16),
child: _dateTile(
                      label: 'Event Date',
date: _date,
icon: Icons.calendar_month_rounded,
onTap: () => _pickDate(deadline: false),
                    ),
                  ),
_dateTile(
                    label: 'Registration Deadline',
date: _deadline,
icon: Icons.event_available_rounded,
onTap: () => _pickDate(deadline: true),
                  ),
                ],
              ),
            ),
const SizedBox(height: 28),

            // Submit Button
AppButton(
              text: editing ? 'Save Changes' : 'Publish Event',
onPressed: _isSaving ? null : _save,
isLoading: _isSaving,
            ),
const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCardWrapper({
    required String title,
 required String subtitle,
 required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
        color: Colors.white,
borderRadius: BorderRadius.circular(18),
border: Border.all(color: Colors.grey.shade200),
boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
blurRadius: 10,
offset: const Offset(0, 4),
          ),
        ],
      ),
child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
children: [
          Text(
            title,
style: const TextStyle(
              fontSize: 17,
fontWeight: FontWeight.w700,
color: Colors.black87,
            ),
          ),
const SizedBox(height: 2),
Text(
            subtitle,
style: TextStyle(
              fontSize: 13,
color: Colors.grey.shade600,
            ),
          ),
const SizedBox(height: 16),
child,
        ],
      ),
    );
  }

  Widget _dateTile({
    required String label,
 required DateTime? date,
 required IconData icon,
 required VoidCallback onTap,
  }) {
    final hasValue = date != null;
    return InkWell(
      onTap: onTap,
borderRadius: BorderRadius.circular(14),
child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
decoration: BoxDecoration(
          color: Colors.white,
borderRadius: BorderRadius.circular(14),
border: Border.all(
            color: hasValue ? AppTheme.primaryOrange : Colors.grey.shade300,
width: 1.2,
          ),
        ),
child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryOrange, size: 22),
const SizedBox(width: 14),
Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
mainAxisSize: MainAxisSize.min,
children: [
                  Text(
                    label,
style: TextStyle(
                      fontSize: 12,
color: Colors.grey.shade600,
fontWeight: FontWeight.w500,
                    ),
                  ),
const SizedBox(height: 2),
Text(
                    _dateLabel(date, 'Tap to select date'),
style: TextStyle(
                      fontSize: 15,
color: hasValue ? Colors.black87 : Colors.grey.shade400,
fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
Icon(
              Icons.arrow_drop_down_rounded,
color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
 String label,
 String hint, {
    int lines = 1,
 bool required = true,
 IconData? icon,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
child: TextFormField(
          controller: controller,
validator: required ? _required : null,
maxLines: lines,
decoration: InputDecoration(
            labelText: label,
hintText: hint,
prefixIcon: icon == null
? null
: Icon(icon, color: AppTheme.primaryOrange, size: 22),
          ),
        ),
      );

  Widget _dropdown(
    String label,
 String value,
 List<String> items,
 IconData icon,
 ValueChanged<String?> onChanged,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
child: DropdownButtonFormField<String>(
          initialValue: value,
decoration: InputDecoration(
            labelText: label,
prefixIcon: Icon(icon, color: AppTheme.primaryOrange, size: 22),
          ),
items: items
.map((item) => DropdownMenuItem(value: item, child: Text(item)))
.toList(),
onChanged: onChanged,
        ),
      );
}