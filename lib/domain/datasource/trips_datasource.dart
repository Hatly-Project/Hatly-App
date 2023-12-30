import 'package:hatly/domain/models/get_all_trips_response_dto.dart';

abstract class TripsDatasource {
  Future<GetAllTripsResponseDto> getAllTrips(String token);
}
