import 'dart:convert';

import 'package:hatly/data/api/countries_states/countries_states.dart';
import 'package:hatly/domain/models/country_dto.dart';

class CountriesDto {
  List<CountriesStatesDto>? countries;

  CountriesDto({this.countries});

  factory CountriesDto.fromMap(List<dynamic> data) => CountriesDto(
      countries: data
          .map((e) => CountriesStatesDto.fromMap(e as Map<String, dynamic>))
          .toList());

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [State].
  factory CountriesDto.fromJson(String data) {
    return CountriesDto.fromMap(json.decode(data) as List<dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [State] to a JSON string.
}
