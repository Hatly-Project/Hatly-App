import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/repository/trips_repository.dart';

class CounterOfferUsecase {
  ShipmentRepository shipmentRepository;
  TripsRepository tripsRepository;

  CounterOfferUsecase(
      {required this.shipmentRepository, required this.tripsRepository});
}
