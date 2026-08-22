import '../../domain/models/event_model.dart';
import '../repositories/event_repository.dart';

class EventService {
  EventService._();

  static final EventService instance =
      EventService._();

  final EventRepository _repository =
      EventRepository.instance;

  Stream<List<EventModel>> getEvents() {
    return _repository.getEvents();
  }

  Stream<List<EventModel>> getEventsByOrganizer(String organizerId) {
    return _repository.getEventsByOrganizer(organizerId);
  }

  Future<EventModel?> getEventById(
    String eventId,
  ) {
    return _repository.getEventById(eventId);
  }

  Future<String> createEvent(
    EventModel event,
  ) {
    return _repository.createEvent(event);
  }

  Future<void> updateEvent(
    EventModel event,
  ) {
    return _repository.updateEvent(event);
  }

  Future<void> deleteEvent(
    String eventId,
  ) {
    return _repository.deleteEvent(eventId);
  }

  Future<List<EventModel>> searchEvents(
    String query,
  ) {
    return _repository.searchEvents(
      query,
    );
  }

  Future<List<EventModel>> filterEvents({
    String? domain,
    DateTime? date,
    bool? isOnline,
    String? level,
  }) {
    return EventRepository.instance.filterEvents(
      domain: domain,
      date: date,
      isOnline: isOnline,
      level: level,
    );
  }
}
