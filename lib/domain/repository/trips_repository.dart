import 'package:hatly/domain/models/create_trip_response_dto.dart';
import 'package:hatly/domain/models/get_all_trips_response_dto.dart';

abstract class TripsRepository {
  Future<GetAllTripsResponseDto> getAllTrips(String token);

  Future<CreateTripResponseDto> createTrip(
      {String? origin,
      String? destination,
      int? available,
      String? note,
      String? addressMeeting,
      String? departDate,
      String? notNeed,
      required String token});
}
