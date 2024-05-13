import 'package:hatly/domain/models/get_trip_deal_details_response_dto.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class GetMyTripDealDetailsUsecase {
  TripsRepository repository;

  GetMyTripDealDetailsUsecase({required this.repository});

  Future<GetTripDealDetailsResponseDto> getMyTripDealDetails(
      {required String token, required int dealId}) {
    return repository.getMytripDealDetails(token: token, dealId: dealId);
  }
}
