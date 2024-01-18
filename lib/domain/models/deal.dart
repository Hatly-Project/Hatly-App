import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';

class Deal {
  ShipmentDto shipmentDto;
  TripsDto tripsDto;

  Deal({required this.shipmentDto, required this.tripsDto});
}
