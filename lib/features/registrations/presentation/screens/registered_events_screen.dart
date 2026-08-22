import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../events/data/services/event_services.dart';
import '../../../events/domain/models/event_model.dart';
import '../../data/services/registration_service.dart';
import '../../domain/models/registration_model.dart';

class RegisteredEventsScreen extends StatelessWidget {
  const RegisteredEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text('Please log in to view registered events.')));

    return Scaffold(
      appBar: AppBar(title: const Text('Registered Events')),
      body: StreamBuilder<List<RegistrationModel>>(
        stream: RegistrationService.instance.getUserRegistrations(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return const Center(child: Text('Unable to load registered events.'));
          final registrations = snapshot.data ?? [];
          if (registrations.isEmpty) return const Center(child: Text('You have not registered for any events yet.'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: registrations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _RegistrationTile(registration: registrations[index]),
          );
        },
      ),
    );
  }
}

class _RegistrationTile extends StatelessWidget {
  const _RegistrationTile({required this.registration});
  final RegistrationModel registration;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EventModel?>(
      future: EventService.instance.getEventById(registration.eventId),
      builder: (context, snapshot) {
        final event = snapshot.data;
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(14),
            leading: const CircleAvatar(child: Icon(Icons.event_available_rounded)),
            title: Text(event?.title ?? registration.eventTitle),
            subtitle: Text(event == null ? 'Event details are no longer available' : '${event.date.day}/${event.date.month}/${event.date.year} • ${event.location}'),
            trailing: event == null ? null : const Icon(Icons.chevron_right_rounded),
            onTap: event == null ? null : () => context.push(AppRoutes.eventDetails, extra: event),
          ),
        );
      },
    );
  }
}
