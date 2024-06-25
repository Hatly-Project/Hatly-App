import 'dart:convert';

import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';

import 'country.dart';

class CountriesStates {
  List<Country>? countries;
  bool? status;

  CountriesStates({this.countries, this.status});

  factory CountriesStates.fromMap(Map<String, dynamic> data) {
    return CountriesStates(
      countries: (data['countries'] as List<dynamic>?)
          ?.map((e) => Country.fromMap(e as Map<String, dynamic>))
          .toList(),
      status: data['status'] as bool?,
    );
  }

  Map<String, dynamic> toMap() => {
        'countries': countries?.map((e) => e.toMap()).toList(),
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CountriesStates].
  factory CountriesStates.fromJson(String data) {
    return CountriesStates.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CountriesStates] to a JSON string.
  String toJson() => json.encode(toMap());

  CountriesDto toDto() {
    return CountriesDto(
      countries: countries?.map((country) => country.toDto()).toList(),
      status: status,
    );
  }
}
