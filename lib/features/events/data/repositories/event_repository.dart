import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/event_model.dart';

class EventRepository {
  EventRepository._();

  static final EventRepository instance =
      EventRepository._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get _eventsCollection {
    return _firestore.collection('events');
  }
  Future<List<EventModel>> searchEvents(
    String query,
  ) async {
    final snapshot = await FirebaseFirestore
        .instance
        .collection('events')
        .get();

    final searchQuery =
        query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      return [];
    }

    return snapshot.docs
        .map(
          EventModel.fromFirestore,
        )
        .where(
          (event) {
            final title =
                event.title.toLowerCase();

            final category =
                event.category.toLowerCase();

            final location =
                event.location.toLowerCase();

            final organizer =
                event.organizer.toLowerCase();

            return title.contains(searchQuery) ||
                category.contains(searchQuery) ||
                location.contains(searchQuery) ||
                organizer.contains(searchQuery);
          },
        )
        .toList();
  }
  Stream<List<EventModel>> getEvents() {
    return _eventsCollection
        .orderBy('date')
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map(
                  EventModel.fromFirestore,
                )
                .toList();
          },
        );
  }

  Future<EventModel?> getEventById(
    String eventId,
  ) async {
    final document =
        await _eventsCollection.doc(eventId).get();

    if (!document.exists) {
      return null;
    }

    return EventModel.fromFirestore(document);
  }

  Future<String> createEvent(
    EventModel event,
  ) async {
    final document =
        await _eventsCollection.add(
      event.toFirestore(),
    );

    return document.id;
  }

  Future<void> updateEvent(
    EventModel event,
  ) async {
    await _eventsCollection
        .doc(event.id)
        .update(event.toFirestore());
  }

  Future<void> deleteEvent(
    String eventId,
  ) async {
    await _eventsCollection
        .doc(eventId)
        .delete();
  }
}