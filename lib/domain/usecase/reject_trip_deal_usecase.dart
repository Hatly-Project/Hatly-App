import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class RejecttripDealUsecase {
  TripsRepository repository;

  RejecttripDealUsecase(this.repository);

  Future<AcceptOrRejectShipmentDealResponseDto> rejectTripDeal(
      {required String token,
      required String dealId,
      required String status,
      required String dealType}) {
    return repository.rejectTripDeal(
        token: token, dealId: dealId, status: status, dealType: dealType);
  }
}
