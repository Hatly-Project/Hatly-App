import 'package:hatly/domain/models/counter_offer_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class ShipmentCounterOfferUsecase {
  ShipmentRepository shipmentRepository;

  ShipmentCounterOfferUsecase({required this.shipmentRepository});

  Future<CounterOfferResponseDto> invoke(
      {required String token, required int dealId, required double reward}) {
    return shipmentRepository.makeCounterOffer(
        token: token, dealId: dealId, reward: reward);
  }
}
