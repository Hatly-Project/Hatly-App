import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';

class GetMyShipmentDealDetailsUsecase {
  ShipmentRepository repository;

  GetMyShipmentDealDetailsUsecase({required this.repository});

  Future<GetMyShipmentDealDetailsResponseDto> getMyShipmentDealDetails(
      {required String token, required String dealId}) {
    return repository.getMyShipmentDealDetails(token: token, dealId: dealId);
  }
}
