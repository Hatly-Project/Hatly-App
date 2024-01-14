import 'dart:convert';

import 'package:hatly/domain/models/country_dto.dart';

class Country {
  String? name;
  String? flag;
  String? iso2;
  String? iso3;

  Country({this.name, this.flag, this.iso2, this.iso3});

  factory Country.fromMap(Map<String, dynamic> data) => Country(
        name: data['name'] as String?,
        flag: data['flag'] as String?,
        iso2: data['iso2'] as String?,
        iso3: data['iso3'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'flag': flag,
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

  CountryDto toCountryDto() {
    return CountryDto(name: name, flag: flag, iso2: iso2, iso3: iso3);
  }
}
