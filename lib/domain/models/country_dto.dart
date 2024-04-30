import 'dart:convert';

import 'package:hatly/domain/models/state_dto.dart';

class CountriesStatesDto {
  String? name;
  String? flag;
  List<StateDto>? states;
  String? currency;
  String? dialCode;
  String? iso2;
  String? iso3;

  CountriesStatesDto({
    this.name,
    this.flag,
    this.states,
    this.currency,
    this.dialCode,
    this.iso2,
    this.iso3,
  });

  factory CountriesStatesDto.fromMap(Map<String, dynamic> data) {
    return CountriesStatesDto(
      name: data['name'] as String?,
      flag: data['flag'] as String?,
      states: (data['states'] as List<dynamic>?)
          ?.map((e) => StateDto.fromMap(e as Map<String, dynamic>))
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
  factory CountriesStatesDto.fromJson(String data) {
    return CountriesStatesDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CountriesStates] to a JSON string.
  String toJson() => json.encode(toMap());
}
