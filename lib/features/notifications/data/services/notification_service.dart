import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../events/domain/models/event_model.dart';
import '../../domain/models/notification_model.dart';

class NotificationService {
  NotificationService._();
static final NotificationService instance = NotificationService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userNotifications(String userId) {
    return _firestore.collection('users').doc(userId).collection('notifications');
  }

  /// Real-time stream of all user notifications, sorted by newest first
  Stream<List<NotificationModel>> getNotificationsStream(String userId) {
    return _userNotifications(userId)
.orderBy('createdAt', descending: true)
.snapshots()
.map((snapshot) {
      return snapshot.docs
.map((doc) => NotificationModel.fromFirestore(doc))
.toList();
    });
  }

  /// Real-time stream of the unread notifications count
  Stream<int> getUnreadCountStream(String userId) {
    return _userNotifications(userId)
.where('isRead', isEqualTo: false)
.snapshots()
.map((snapshot) => snapshot.docs.length);
  }

  /// Create a notification
  Future<String> createNotification(NotificationModel notification) async {
    try {
      final docRef = await _userNotifications(notification.userId)
.add(notification.toFirestore());
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating notification: $e');
      rethrow;
    }
  }

  /// Triggered immediately upon successful event registration
  Future<void> notifyRegistrationSuccess({
    required String userId,
 required EventModel event,
  }) async {
    try {
      final formattedDate = '${event.date.day}/${event.date.month}/${event.date.year}';
      final notification = NotificationModel(
        id: '',
userId: userId,
title: 'Registration Confirmed! 🎉',
message: 'You have successfully registered for "${event.title}". '
            'Date: $formattedDate at ${event.time}. Venue: ${event.location}.',
type: NotificationType.registrationSuccess,
eventId: event.id,
eventTitle: event.title,
isRead: false,
createdAt: DateTime.now(),
      );

      await createNotification(notification);
    } catch (e) {
      debugPrint('Failed to send registration notification: $e');
    }
  }

  /// Triggered when an organizer publishes an event
  Future<void> notifyEventPublished({
    required String organizerId,
 required EventModel event,
  }) async {
    try {
      final notification = NotificationModel(
        id: '',
userId: organizerId,
title: 'Event Published! 🚀',
message: 'Your event "${event.title}" is now live on TechCulture for attendees to explore.',
type: NotificationType.eventPublished,
eventId: event.id,
eventTitle: event.title,
isRead: false,
createdAt: DateTime.now(),
      );

      await createNotification(notification);
    } catch (e) {
      debugPrint('Failed to send event published notification: $e');
    }
  }

  /// Checks registered events and creates a reminder if starting within 24 hours
  Future<void> checkAndNotifyUpcomingEvents({
    required String userId,
  }) async {
    try {
      final now = DateTime.now();
      // Fetch user registrations
      final regSnapshot = await _firestore
.collection('registrations')
.where('userId', isEqualTo: userId)
.get();

if (regSnapshot.docs.isEmpty) return;

      for (final doc in regSnapshot.docs) {
        final data = doc.data();
        final eventId = data['eventId'] as String?;
if (eventId == null || eventId.isEmpty) continue;

        // Fetch event data
        final eventDoc = await _firestore.collection('events').doc(eventId).get();
if (!eventDoc.exists) continue;

        final eventData = eventDoc.data()!;
        final dynamic rawDate = eventData['date'];
        DateTime? eventDate;
if (rawDate is Timestamp) {
          eventDate = rawDate.toDate();
        }

if (eventDate == null) continue;

        // If event is starting in the next 24 hours and is not yet in the past
        final difference = eventDate.difference(now);
        final isStartingSoon = difference.inHours >= 0 && difference.inHours <= 24;

if (isStartingSoon) {
          // Check if a starting soon notification was already created for this event
          final existingNotifs = await _userNotifications(userId)
.where('eventId', isEqualTo: eventId)
.where('type', isEqualTo: 'event_starting_soon')
.limit(1)
.get();

if (existingNotifs.docs.isEmpty) {
            final eventTitle = eventData['title'] as String? ?? 'Event';
            final timeStr = eventData['time'] as String? ?? '';
            final locationStr = eventData['location'] as String? ?? '';

            final notification = NotificationModel(
              id: '',
userId: userId,
title: 'Event Starting Soon! ⏰',
message: '"$eventTitle" starts in less than 24 hours (${eventDate.day}/${eventDate.month}/${eventDate.year} at $timeStr). Venue: $locationStr.',
type: NotificationType.eventStartingSoon,
eventId: eventId,
eventTitle: eventTitle,
isRead: false,
createdAt: DateTime.now(),
            );

            await createNotification(notification);
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking upcoming events for notifications: $e');
    }
  }

  /// Mark single notification as read
  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await _userNotifications(userId).doc(notificationId).update({'isRead': true});
    } catch (e) {
      debugPrint('Failed to mark notification as read: $e');
    }
  }

  /// Mark all user notifications as read
  Future<void> markAllAsRead(String userId) async {
    try {
      final unreadDocs = await _userNotifications(userId)
.where('isRead', isEqualTo: false)
.get();

if (unreadDocs.docs.isEmpty) return;

      final batch = _firestore.batch();
      for (final doc in unreadDocs.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Failed to mark all notifications as read: $e');
    }
  }

  /// Delete single notification
  Future<void> deleteNotification(String userId, String notificationId) async {
    try {
      await _userNotifications(userId).doc(notificationId).delete();
    } catch (e) {
      debugPrint('Failed to delete notification: $e');
    }
  }

  /// Clear all notifications
  Future<void> clearAll(String userId) async {
    try {
      final allDocs = await _userNotifications(userId).get();
if (allDocs.docs.isEmpty) return;

      final batch = _firestore.batch();
      for (final doc in allDocs.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Failed to clear all notifications: $e');
    }
  }
}
