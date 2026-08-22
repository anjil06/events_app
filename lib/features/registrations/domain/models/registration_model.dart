import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationModel {
  final String id;
  final String userId;
  final String eventId;
  final String eventTitle;
  final String userEmail;
  final String userName;
  final DateTime registeredAt;
  final String status;

  const RegistrationModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.eventTitle,
    required this.userEmail,
    required this.userName,
    required this.registeredAt,
    required this.status,
  });

  factory RegistrationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    if (data == null) {
      throw Exception(
        'Registration data is empty',
      );
    }

    return RegistrationModel(
      id: document.id,
      userId: data['userId'] ?? '',
      eventId: data['eventId'] ?? '',
      eventTitle: data['eventTitle'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userName: data['userName'] ?? '',
      registeredAt: _parseDate(
        data['registeredAt'],
      ),
      status: data['status'] ?? 'registered',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'eventId': eventId,
      'eventTitle': eventTitle,
      'userEmail': userEmail,
      'userName': userName,
      'registeredAt':
          FieldValue.serverTimestamp(),
      'status': status,
    };
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
  }
}
