import 'package:hatly/domain/models/shipment_matching_trips_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';

class GetShipmentMatchingTripsUsecase {
  ShipmentRepository repository;

  GetShipmentMatchingTripsUsecase({required this.repository});

  Future<ShipmentMatchingTripsResponseDto> getShipmentMatchingTrips(
      {required String token, required int shipmentId}) {
    return repository.getShipmentMatchingTrips(
        token: token, shipmentId: shipmentId);
  }
}
