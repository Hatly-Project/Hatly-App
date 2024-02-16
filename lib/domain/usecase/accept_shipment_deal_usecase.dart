import 'package:hatly/domain/models/accept_shipment_deal_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';

class AcceptShipmentDealUsecase {
  ShipmentRepository repository;

  AcceptShipmentDealUsecase(this.repository);

  Future<AcceptShipmentDealResponseDto> acceptShipmentDeal(
      {required String token, required String dealId, required String status}) {
    return repository.acceptShipmentDeal(
        token: token, dealId: dealId, status: status);
  }
}
