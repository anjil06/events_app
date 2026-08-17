import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/registration_model.dart';

class RegistrationRepository {
  RegistrationRepository._();

  static final RegistrationRepository instance =
      RegistrationRepository._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get _registrationsCollection {
    return _firestore.collection('registrations');
  }

  Future<bool> isUserRegistered({
    required String userId,
    required String eventId,
  }) async {
    final snapshot = await _registrationsCollection
        .where(
          'userId',
          isEqualTo: userId,
        )
        .where(
          'eventId',
          isEqualTo: eventId,
        )
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<String> registerForEvent(
    RegistrationModel registration,
  ) async {
    final document =
        await _registrationsCollection.add(
      registration.toFirestore(),
    );

    return document.id;
  }

  Stream<List<RegistrationModel>>
      getUserRegistrations(
    String userId,
  ) {
    return _registrationsCollection
        .where(
          'userId',
          isEqualTo: userId,
        )
        .orderBy(
          'registeredAt',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map(
                  RegistrationModel
                      .fromFirestore,
                )
                .toList();
          },
        );
  }
}