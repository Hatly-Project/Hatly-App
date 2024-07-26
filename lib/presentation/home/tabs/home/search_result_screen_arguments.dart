import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';

class SearchResultScreenArguments {
  List<ShipmentDto>? shipments;
  List<TripsDto>? trips;
  String? fromCountry, fromCountryFlag, toCountryName, toCountryFlag;
  CountriesDto countriesFlagsDto;

  SearchResultScreenArguments(
      {this.shipments,
      this.trips,
      this.fromCountry,
      this.fromCountryFlag,
      this.toCountryFlag,
      this.toCountryName,
      required this.countriesFlagsDto});
}
