import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String domain;
  final String organizer;
  final String organizerName;
  final DateTime date;
  final String time;
  final String location;
  final bool isOnline;
  final String level;
  final DateTime registrationDeadline;
  final String imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.domain,
    required this.organizer,
    required this.organizerName,
    required this.date,
    required this.time,
    required this.location,
    required this.isOnline,
    required this.level,
    required this.registrationDeadline,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory EventModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    if (data == null) {
      throw Exception('Event data is empty.');
    }

    return EventModel(
      id: document.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      domain: data['domain'] ?? '',
      organizer: data['organizer'] ?? '',
      organizerName: data['organizerName'] ?? '',
      date: _toDateTime(data['date']),
      time: data['time'] ?? '',
      location: data['location'] ?? '',
      isOnline: data['isOnline'] ?? false,
      level: data['level'] ?? 'Beginner',
      registrationDeadline:
          _toDateTime(data['registrationDeadline']),
      imageUrl: data['imageUrl'] ?? '',
      createdAt: _toNullableDateTime(
        data['createdAt'],
      ),
      updatedAt: _toNullableDateTime(
        data['updatedAt'],
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'domain': domain,
      'organizerId': organizer,
      'organizerName': organizerName,
      'date': Timestamp.fromDate(date),
      'time': time,
      'location': location,
      'isOnline': isOnline,
      'level': level,
      'registrationDeadline':
          Timestamp.fromDate(registrationDeadline),
      'imageUrl': imageUrl,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
  }

  static DateTime? _toNullableDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}