import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkModel {
  final String id;
  final String userId;
  final String eventId;
  final String eventTitle;
  final DateTime savedAt;

  const BookmarkModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.eventTitle,
    required this.savedAt,
  });

  factory BookmarkModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    if (data == null) {
      throw Exception('Bookmark data is empty');
    }

    return BookmarkModel(
      id: document.id,
      userId: data['userId'] ?? '',
      eventId: data['eventId'] ?? '',
      eventTitle: data['eventTitle'] ?? '',
      savedAt: _parseDate(data['savedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'eventId': eventId,
      'eventTitle': eventTitle,
      'savedAt': FieldValue.serverTimestamp(),
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