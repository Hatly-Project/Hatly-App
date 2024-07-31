import 'package:hatly/domain/models/shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trip_deal_response.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class SendShipmentDealUsecase {
  ShipmentRepository repository;

  SendShipmentDealUsecase({required this.repository});

  // Future<TripDealResponseDto> sendDeal(
  //     { String? shipmentId,
  //     required double? reward,
  //     required String token,
  //     required int tripId}) {
  //   return repository.sendDeal(
  //       token: token, shipmentId: shipmentId, reward: reward, tripId: tripId);
  // }
}
