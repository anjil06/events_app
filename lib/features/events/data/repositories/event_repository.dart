import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/event_model.dart';

class EventRepository {
  EventRepository._();

  static final EventRepository instance = EventRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _eventsCollection {
    return _firestore.collection('events');
  }

  Future<List<EventModel>> filterEvents({
  String? domain,
  DateTime? date,
  bool? isOnline,
  String? level,
}) async {
  final snapshot = await _eventsCollection.get();

  return snapshot.docs
      .map(EventModel.fromFirestore)
      .where((event) {
    if (domain != null &&
        domain.isNotEmpty &&
        event.domain.toLowerCase() !=
            domain.toLowerCase()) {
      return false;
    }

    if (date != null) {
      final sameDate =
          event.date.year == date.year &&
          event.date.month == date.month &&
          event.date.day == date.day;

      if (!sameDate) {
        return false;
      }
    }

    if (isOnline != null &&
        event.isOnline != isOnline) {
      return false;
    }

    if (level != null &&
        level.isNotEmpty &&
        event.level.toLowerCase() !=
            level.toLowerCase()) {
      return false;
    }

    return true;
  }).toList();
}

  Future<List<EventModel>> searchEvents(String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .get();

    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      return [];
    }

    return snapshot.docs.map(EventModel.fromFirestore).where((event) {
      final title = event.title.toLowerCase();

      final category = event.category.toLowerCase();

      final location = event.location.toLowerCase();

      final organizer = event.organizerId.toLowerCase();

      final organizerName = event.organizerName.toLowerCase();

      return title.contains(searchQuery) ||
          category.contains(searchQuery) ||
          location.contains(searchQuery) ||
          organizer.contains(searchQuery) ||
          organizerName.contains(searchQuery);
    }).toList();
  }

  Stream<List<EventModel>> getEvents() {
    return _eventsCollection.orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs.map(EventModel.fromFirestore).toList();
    });
  }

  Stream<List<EventModel>> getEventsByOrganizer(String organizerId) {
    return _eventsCollection
        .where('organizerId', isEqualTo: organizerId)
        .snapshots()
        .map((snapshot) {
      final events = snapshot.docs.map(EventModel.fromFirestore).toList();
      events.sort((first, second) => first.date.compareTo(second.date));
      return events;
    });
  }

  Future<EventModel?> getEventById(String eventId) async {
    final document = await _eventsCollection.doc(eventId).get();

    if (!document.exists) {
      return null;
    }

    return EventModel.fromFirestore(document);
  }

  Future<String> createEvent(EventModel event) async {
    final document = await _eventsCollection.add(event.toFirestore());

    return document.id;
  }

  Future<void> updateEvent(EventModel event) async {
    await _eventsCollection.doc(event.id).update(event.toFirestore());
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventsCollection.doc(eventId).delete();
  }
}
