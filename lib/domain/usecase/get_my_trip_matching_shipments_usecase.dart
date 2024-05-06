import 'package:hatly/domain/models/trip_matching_shipments_response_dto.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class GetMyTripMatchingShipmentsUsecase {
  TripsRepository repository;

  GetMyTripMatchingShipmentsUsecase({required this.repository});

  Future<TripMatchingShipmentsResponseDto> invoke(
      {required String token, required int tripId}) {
    return repository.getTripMatchingShipments(token: token, tripId: tripId);
  }
}
