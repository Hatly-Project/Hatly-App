import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class AcceptTripDealUsecase {
  TripsRepository repository;

  AcceptTripDealUsecase(this.repository);

  Future<AcceptOrRejectShipmentDealResponseDto> acceptTripDeal({
    required String token,
    required String dealId,
    required String status,
    required String dealType,
  }) {
    return repository.acceptTripDeal(
        token: token, dealId: dealId, status: status, dealType: dealType);
  }
}
