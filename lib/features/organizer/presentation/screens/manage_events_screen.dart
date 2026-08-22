import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../events/data/services/event_services.dart';
import '../../../events/domain/models/event_model.dart';
import '../../../registrations/data/services/registration_service.dart';
import '../../../registrations/domain/models/registration_model.dart';

class ManageEventsScreen extends StatelessWidget {
  const ManageEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text('Please log in to manage events.')));
    return Scaffold(
      appBar: AppBar(title: const Text('Manage My Events')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.eventForm),
        icon: const Icon(Icons.add_rounded), label: const Text('Create event'),
      ),
      body: StreamBuilder<List<EventModel>>(
        stream: EventService.instance.getEventsByOrganizer(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return const Center(child: Text('Unable to load your events.'));
          final events = snapshot.data ?? [];
          if (events.isEmpty) return _EmptyEvents(onCreate: () => context.push(AppRoutes.eventForm));
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _ManagedEventCard(event: events[index]),
          );
        },
      ),
    );
  }
}

class _ManagedEventCard extends StatelessWidget {
  const _ManagedEventCard({required this.event});
  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('${event.date.day}/${event.date.month}/${event.date.year} • ${event.location}', style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 12),
            StreamBuilder<List<RegistrationModel>>(
              stream: RegistrationService.instance.getEventRegistrations(event.id),
              builder: (context, snapshot) {
                final count = snapshot.data?.length ?? 0;
                return InkWell(
                  onTap: () => context.push(AppRoutes.eventRegistrations, extra: event),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(color: AppTheme.lightOrange, borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [const Icon(Icons.people_alt_outlined, color: AppTheme.primaryOrange), const SizedBox(width: 8), Text('$count registered', style: const TextStyle(color: AppTheme.primaryOrange, fontWeight: FontWeight.w700)), const Spacer(), const Icon(Icons.chevron_right_rounded, color: AppTheme.primaryOrange)]),
                  ),
                );
              },
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(onPressed: () => context.push(AppRoutes.eventForm, extra: event), icon: const Icon(Icons.edit_outlined), label: const Text('Edit')),
                TextButton.icon(onPressed: () => _confirmDelete(context), icon: const Icon(Icons.delete_outline), label: const Text('Delete'), style: TextButton.styleFrom(foregroundColor: Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final delete = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('Delete event?'), content: const Text('This removes the event from the app. Existing registrations will not be deleted.'),
      actions: [TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(dialogContext, true), style: FilledButton.styleFrom(backgroundColor: Colors.red), child: const Text('Delete'))],
    ));
    if (delete != true) return;
    try {
      await EventService.instance.deleteEvent(event.id);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event deleted.')));
    } catch (_) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to delete event.')));
    }
  }
}

class _EmptyEvents extends StatelessWidget {
  const _EmptyEvents({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.campaign_outlined, size: 70, color: AppTheme.primaryOrange), const SizedBox(height: 16),
        const Text('Create your first event', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)), const SizedBox(height: 8),
        Text('Publish technical events and manage attendees in one place.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700)), const SizedBox(height: 20),
        ElevatedButton(onPressed: onCreate, child: const Text('Create event')),
      ]),
    ),
  );
}
