import 'package:hatly/domain/models/get_user_trip_response_dto.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class GetUserTripUsecase {
  TripsRepository repository;

  GetUserTripUsecase(this.repository);

  Future<GetUserTripResponseDto> getUserTrip({required String token}) {
    return repository.getUserTrip(token: token);
  }
}
