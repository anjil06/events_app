import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../events/data/services/event_services.dart';
import '../../../events/domain/models/event_model.dart';

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
  late final TextEditingController _imageUrl;
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
    _imageUrl = TextEditingController(text: event?.imageUrl ?? '');
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
    _imageUrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool deadline}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: (deadline ? _deadline : _date) ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 1095)),
    );
    if (selected != null && mounted) setState(() { if (deadline) _deadline = selected; else _date = selected; });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _date == null || _deadline == null) {
      if (_date == null || _deadline == null) _message('Select the event date and registration deadline.');
      return;
    }
    if (_deadline!.isAfter(_date!)) {
      _message('Registration deadline must be on or before the event date.');
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) { _message('Please log in to create an event.'); return; }
    if (widget.event != null && widget.event!.organizerId != user.uid) {
      _message('You can only edit events that you created.');
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
      organizerName: existing?.organizerName ?? (user.displayName?.trim().isNotEmpty == true ? user.displayName!.trim() : user.email ?? 'TechScope organizer'),
      date: _date!, time: _time.text.trim(), location: _location.text.trim(), isOnline: _isOnline,
      level: _level, registrationDeadline: _deadline!, imageUrl: _imageUrl.text.trim(),
      createdAt: existing?.createdAt,
    );
    try {
      if (existing == null) { await EventService.instance.createEvent(event); } else { await EventService.instance.updateEvent(event); }
      if (mounted) { _message(existing == null ? 'Event published.' : 'Event updated.'); Navigator.pop(context); }
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
            Text(editing ? 'Update your event details.' : 'Publish an event for the TechScope community.', style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 20),
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
            _field(_imageUrl, 'Image URL (optional)', 'https://...', required: false),
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
    child: DropdownButtonFormField<String>(value: value, decoration: InputDecoration(labelText: label), items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(), onChanged: onChanged),
  );
}
