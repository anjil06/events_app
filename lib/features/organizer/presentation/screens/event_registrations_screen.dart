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
      backgroundColor: const Color(0xFFF9FAFB),
appBar: AppBar(
        title: const Text('Event Registrations'),
      ),
body: StreamBuilder<List<RegistrationModel>>(
        stream: RegistrationService.instance.getEventRegistrations(event.id),
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B00)));
          }
if (snapshot.hasError) {
            return const Center(child: Text('Unable to load registrations.'));
          }
          final registrations = snapshot.data ?? [];
          return Column(
            children: [
              Container(
                width: double.infinity,
margin: const EdgeInsets.all(16),
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E8),
borderRadius: BorderRadius.circular(18),
border: Border.all(color: const Color(0xFFFF6B00).withValues(alpha: 0.2)),
                ),
child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
children: [
                    Text(
                      event.title,
style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
const SizedBox(height: 6),
Text(
                      '${registrations.length} attendee${registrations.length == 1 ? '' : 's'} registered',
style: const TextStyle(color: Color(0xFFFF6B00), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
Expanded(
                child: registrations.isEmpty
? const Center(child: Text('No registrations yet.'))
: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
itemCount: registrations.length,
separatorBuilder: (_, index) => const SizedBox(height: 12),
itemBuilder: (context, index) => _AttendeeTile(registration: registrations[index]),
                      ),
              ),
            ],
          );
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
leading: CircleAvatar(
          backgroundColor: const Color(0xFFFFF3E8),
child: Text(
            registration.userEmail.isEmpty ? '?' : registration.userEmail[0].toUpperCase(),
style: const TextStyle(color: Color(0xFFFF6B00), fontWeight: FontWeight.w700),
          ),
        ),
title: Text(
          registration.userName.isEmpty ? 'Attendee' : registration.userName,
style: const TextStyle(fontWeight: FontWeight.w700),
        ),
subtitle: Text(
          '${registration.userEmail.isEmpty ? 'Email unavailable' : registration.userEmail}\nRegistered on ${date.day}/${date.month}/${date.year} • ${registration.status}',
        ),
isThreeLine: true,
      ),
    );
  }
}
