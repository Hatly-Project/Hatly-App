import 'dart:convert';

import 'package:hatly/domain/models/countries_flags_dto.dart';

import 'country.dart';

class CountriesFlags {
  bool? error;
  String? msg;
  List<Country>? countries;

  CountriesFlags({this.error, this.msg, this.countries});

  factory CountriesFlags.fromMap(Map<String, dynamic> data) {
    return CountriesFlags(
      error: data['error'] as bool?,
      msg: data['msg'] as String?,
      countries: (data['data'] as List<dynamic>?)
          ?.map((e) => Country.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'error': error,
        'msg': msg,
        'data': countries?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CountriesFlags].
  factory CountriesFlags.fromJson(String data) {
    return CountriesFlags.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CountriesFlags] to a JSON string.
  String toJson() => json.encode(toMap());

  CountriesFlagsDto toCountriesFlagsDto() {
    return CountriesFlagsDto(
        error: error,
        msg: msg,
        countries:
            countries?.map((country) => country.toCountryDto()).toList());
  }
}
