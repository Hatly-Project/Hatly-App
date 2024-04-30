import 'dart:convert';

import 'package:hatly/data/api/countries_states/state.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';

class CountriesStates {
  String? name;
  String? flag;
  List<State>? states;
  String? currency;
  String? dialCode;
  String? iso2;
  String? iso3;

  CountriesStates({
    this.name,
    this.flag,
    this.states,
    this.currency,
    this.dialCode,
    this.iso2,
    this.iso3,
  });

  factory CountriesStates.fromMap(Map<String, dynamic> data) {
    return CountriesStates(
      name: data['name'] as String?,
      flag: data['flag'] as String?,
      states: (data['states'] as List<dynamic>?)
          ?.map((e) => State.fromMap(e as Map<String, dynamic>))
          .toList(),
      currency: data['currency'] as String?,
      dialCode: data['dialCode'] as String?,
      iso2: data['iso2'] as String?,
      iso3: data['iso3'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'flag': flag,
        'states': states?.map((e) => e.toMap()).toList(),
        'currency': currency,
        'dialCode': dialCode,
        'iso2': iso2,
        'iso3': iso3,
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

  CountriesStatesDto toCountriesStateDto() {
    return CountriesStatesDto(
      name: name,
      flag: flag,
      states: states?.map((state) => state.toStatesDto()).toList(),
      currency: currency,
      dialCode: dialCode,
      iso2: iso2,
      iso3: iso3,
    );
  }
}
