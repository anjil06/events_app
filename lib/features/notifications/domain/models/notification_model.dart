import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  registrationSuccess,
  eventStartingSoon,
  eventPublished,
  general,
}

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final String? eventId;
  final String? eventTitle;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.eventId,
    this.eventTitle,
    this.isRead = false,
    required this.createdAt,
  });

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    String? eventId,
    String? eventTitle,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory NotificationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      message: data['message'] as String? ?? '',
      type: _typeFromString(data['type'] as String?),
      eventId: data['eventId'] as String?,
      eventTitle: data['eventTitle'] as String?,
      isRead: data['isRead'] as bool? ?? false,
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'type': _typeToString(type),
      'eventId': eventId,
      'eventTitle': eventTitle,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static NotificationType _typeFromString(String? value) {
    switch (value) {
      case 'registration_success':
        return NotificationType.registrationSuccess;
      case 'event_starting_soon':
        return NotificationType.eventStartingSoon;
      case 'event_published':
        return NotificationType.eventPublished;
      default:
        return NotificationType.general;
    }
  }

  static String _typeToString(NotificationType type) {
    switch (type) {
      case NotificationType.registrationSuccess:
        return 'registration_success';
      case NotificationType.eventStartingSoon:
        return 'event_starting_soon';
      case NotificationType.eventPublished:
        return 'event_published';
      case NotificationType.general:
        return 'general';
    }
  }
}
