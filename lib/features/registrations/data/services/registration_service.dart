import '../../domain/models/registration_model.dart';
import '../repositories/registration_repository.dart';

class RegistrationService {
  RegistrationService._();

  static final RegistrationService instance =
      RegistrationService._();

  final RegistrationRepository _repository =
      RegistrationRepository.instance;

  Future<bool> isUserRegistered({
    required String userId,
    required String eventId,
  }) {
    return _repository.isUserRegistered(
      userId: userId,
      eventId: eventId,
    );
  }

  Future<String> registerForEvent(
    RegistrationModel registration,
  ) {
    return _repository.registerForEvent(
      registration,
    );
  }

  Stream<List<RegistrationModel>>
      getUserRegistrations(
    String userId,
  ) {
    return _repository.getUserRegistrations(
      userId,
    );
  }

  Stream<List<RegistrationModel>> getEventRegistrations(String eventId) {
    return _repository.getEventRegistrations(eventId);
  }
}
