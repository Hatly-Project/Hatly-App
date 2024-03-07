import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';

class RejectShipmentDealUsecase {
  ShipmentRepository repository;

  RejectShipmentDealUsecase(this.repository);

  Future<AcceptOrRejectShipmentDealResponseDto> rejectShipmentDeal(
      {required String token, required String dealId, required String status}) {
    return repository.rejectShipmentDeal(
        token: token, dealId: dealId, status: status);
  }
}
