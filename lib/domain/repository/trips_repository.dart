import 'package:hatly/domain/models/get_all_trips_response_dto.dart';

abstract class TripsRepository {
  Future<GetAllTripsResponseDto> getAllTrips();
}
