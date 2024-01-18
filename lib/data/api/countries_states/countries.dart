import 'dart:convert';

import 'package:hatly/data/api/countries_states/countries_states.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';

import 'state.dart';

class Countries {
  List<CountriesStates>? countries;

  Countries({this.countries});

  factory Countries.fromMap(List<dynamic> data) => Countries(
      countries: data
          .map((e) => CountriesStates.fromMap(e as Map<String, dynamic>))
          .toList());

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [State].
  factory Countries.fromJson(String data) {
    return Countries.fromMap(json.decode(data) as List<dynamic>);
  }

  CountriesDto toCountriesDto() {
    return CountriesDto(
        countries: countries
            ?.map((country) => country.toCountriesStateDto())
            .toList());
  }

  /// `dart:convert`
  ///
  /// Converts [State] to a JSON string.
}
