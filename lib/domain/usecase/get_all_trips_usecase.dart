import 'package:hatly/domain/models/get_all_trips_response_dto.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class GetAllTripsUsecase {
  TripsRepository tripsRepository;

  GetAllTripsUsecase(this.tripsRepository);

  Future<GetAllTripsResponseDto> invoke({required String token, int page = 1}) {
    return tripsRepository.getAllTrips(token: token, page: page);
  }
}
