import 'package:hatly/domain/models/get_all_trips_response_dto.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class GetAllTripsUsecase {
  TripsRepository tripsRepository;

  GetAllTripsUsecase(this.tripsRepository);

  Future<GetAllTripsResponseDto> invoke(
      {required String token,
      String? beforeExpectedDate,
      String? afterExpectedDate,
      String? from,
      String? fromCity,
      String? to,
      String? toCity,
      bool? latest,
      int page = 1}) {
    return tripsRepository.getAllTrips(
        token: token,
        page: page,
        beforeExpectedDate: beforeExpectedDate,
        afterExpectedDate: afterExpectedDate,
        from: from,
        fromCity: fromCity,
        to: to,
        toCity: toCity);
  }
}
