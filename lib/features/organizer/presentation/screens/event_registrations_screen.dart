import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../events/domain/models/event_model.dart';
import '../../../registrations/data/services/registration_service.dart';
import '../../../registrations/domain/models/registration_model.dart';

class EventRegistrationsScreen extends StatelessWidget {
  const EventRegistrationsScreen({super.key, required this.event});
  final EventModel event;

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser?.uid != event.organizerId) {
      return const Scaffold(body: Center(child: Text('You are not allowed to view these registrations.')));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Registrations')
      ),
      body: StreamBuilder<List<RegistrationModel>>(
        stream: RegistrationService.instance.getEventRegistrations(event.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return const Center(child: Text('Unable to load registrations.'));
          final registrations = snapshot.data ?? [];
          return Column(children: [
            Container(
              width: double.infinity, 
              padding: const EdgeInsets.all(20), 
              color: Colors.orange.shade50, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text(event.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), 
                  const SizedBox(height: 4), 
                  Text('${registrations.length} attendee${registrations.length == 1 ? '' : 's'} registered') 
                ]
              )
            ),
            Expanded(
              child: registrations.isEmpty ? const Center(
                child: Text('No registrations yet.')
              ) : ListView.separated(
              padding: const EdgeInsets.all(16), 
              itemCount: registrations.length, 
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _AttendeeTile(registration: registrations[index]),
            )),
          ]);
        },
      ),
    );
  }
}

class _AttendeeTile extends StatelessWidget {
  const _AttendeeTile({required this.registration});
  final RegistrationModel registration;

  @override
  Widget build(BuildContext context) {
    final date = registration.registeredAt;
    return Card(child: ListTile(
      leading: CircleAvatar(child: Text(registration.userEmail.isEmpty ? '?' : registration.userEmail[0].toUpperCase())),
      title: Text(registration.userName.isEmpty ? 'Attendee' : registration.userName),
      subtitle: Text('${registration.userEmail.isEmpty ? 'Email unavailable' : registration.userEmail}\nRegistered on ${date.day}/${date.month}/${date.year} • ${registration.status}'),
      isThreeLine: true,
    ));
  }
}
