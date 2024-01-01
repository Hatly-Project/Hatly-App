import 'package:hatly/domain/models/create_trip_response_dto.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class CreateTripUsecase {
  TripsRepository repository;

  CreateTripUsecase(this.repository);

  Future<CreateTripResponseDto> invoke(
      {String? origin,
      String? destination,
      int? available,
      String? note,
      String? addressMeeting,
      String? departDate,
      String? notNeed,
      required String token}) async {
    return repository.createTrip(
        token: token,
        origin: origin,
        destination: destination,
        available: available,
        note: note,
        notNeed: notNeed,
        addressMeeting: addressMeeting,
        departDate: departDate);
  }
}
