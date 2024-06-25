import 'dart:convert';

import 'package:hatly/domain/models/country_dto.dart';

import 'state.dart';

class Country {
  String? name;
  String? flag;
  List<State>? states;
  String? currency;
  String? dialCode;
  String? iso2;
  String? iso3;

  Country({
    this.name,
    this.flag,
    this.states,
    this.currency,
    this.dialCode,
    this.iso2,
    this.iso3,
  });

  factory Country.fromMap(Map<String, dynamic> data) => Country(
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
  /// Parses the string and returns the resulting Json object as [Country].
  factory Country.fromJson(String data) {
    return Country.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Country] to a JSON string.
  String toJson() => json.encode(toMap());

  CountriesStatesDto toDto() {
    return CountriesStatesDto(
        name: name,
        flag: flag,
        states: states?.map((state) => state.toDto()).toList(),
        currency: currency,
        dialCode: dialCode,
        iso2: iso2,
        iso3: iso3);
  }
}
