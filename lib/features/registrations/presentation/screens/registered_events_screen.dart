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
      backgroundColor: const Color(0xFFF9FAFB),
appBar: AppBar(title: const Text('Registered Events')),
body: StreamBuilder<List<RegistrationModel>>(
        stream: RegistrationService.instance.getUserRegistrations(user.uid),
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B00)));
          }
if (snapshot.hasError) return const Center(child: Text('Unable to load registered events.'));
          final registrations = snapshot.data ?? [];
if (registrations.isEmpty) return const Center(child: Text('You have not registered for any events yet.'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
itemCount: registrations.length,
separatorBuilder: (_, index) => const SizedBox(height: 14),
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
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: Colors.grey.shade200),
boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
blurRadius: 8,
offset: const Offset(0, 2),
              ),
            ],
          ),
child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFF3E8),
child: Icon(Icons.event_available_rounded, color: Color(0xFFFF6B00)),
            ),
title: Text(
              event?.title ?? registration.eventTitle,
style: const TextStyle(fontWeight: FontWeight.w700),
            ),
subtitle: Text(event == null
? 'Event details are no longer available'
: '${event.date.day}/${event.date.month}/${event.date.year} • ${event.location}'),
trailing: event == null
? null
: const Icon(Icons.chevron_right_rounded, color: Color(0xFFFF6B00)),
onTap: event == null ? null : () => context.push(AppRoutes.eventDetails, extra: event),
          ),
        );
      },
    );
  }
}
