import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/data/api/trip.dart';
import 'package:hatly/domain/models/deal.dart';
import 'package:hatly/domain/models/deal_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trip_deal_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';

class MyTripDealDetailsArgument {
  TripDealDto? deal;
  TripsDto? tripsDto;
  // ShipmentDto? shipmentDto;

  MyTripDealDetailsArgument({this.deal, this.tripsDto});
}
