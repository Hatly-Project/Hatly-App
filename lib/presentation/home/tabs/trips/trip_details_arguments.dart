import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';

class TripDetailsArguments {
  TripsDto tripsDto;
  List<CountriesStatesDto>? countriesStatesDto;

  TripDetailsArguments({required this.tripsDto , required this.countriesStatesDto});
}
