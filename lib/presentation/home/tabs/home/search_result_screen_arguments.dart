import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';

class SearchResultScreenArguments {
  List<ShipmentDto>? shipments;
  List<TripsDto>? trips;
  String? fromCountry,
      fromCountryFlag,
      toCountryName,
      toCountryFlag,
      fromCountryIso,
      toCountryIso;
  CountriesDto countriesFlagsDto;
  int? currentShipmentsPage, totalShipmentsPage, totalData;
  bool? isShipmentSearch, isTripSearch, isAllShipments, isAllTrips;
  SearchResultScreenArguments(
      {this.shipments,
      this.trips,
      this.isAllShipments = false,
      this.isAllTrips = false,
      this.fromCountry,
      this.fromCountryFlag,
      this.toCountryFlag,
      this.toCountryName,
      this.fromCountryIso,
      this.toCountryIso,
      this.currentShipmentsPage,
      this.totalShipmentsPage,
      this.totalData,
      this.isShipmentSearch = false,
      this.isTripSearch = false,
      required this.countriesFlagsDto});
}
