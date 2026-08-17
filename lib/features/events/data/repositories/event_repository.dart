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