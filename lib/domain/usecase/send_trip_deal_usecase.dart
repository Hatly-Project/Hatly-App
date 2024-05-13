import 'package:hatly/domain/models/shipment_deal_response_dto.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class SendTripDealUsecase {
  TripsRepository repository;

  SendTripDealUsecase({required this.repository});

  Future<ShipmentDealResponseDto> sendDeal(
      {int? shipmentId,
      double? reward,
      required String token,
      required int tripId}) {
    return repository.sendDeal(
        token: token, shipmentId: shipmentId, reward: reward, tripId: tripId);
  }
}
