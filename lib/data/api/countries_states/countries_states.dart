import 'dart:convert';

import 'package:hatly/domain/models/country_dto.dart';

import 'state.dart';

class CountriesStates {
  String? name;
  String? flag;
  List<State>? states;

  CountriesStates({this.name, this.flag, this.states});

  factory CountriesStates.fromMap(Map<String, dynamic> data) {
    return CountriesStates(
      name: data['name'] as String?,
      flag: data['flag'] as String?,
      states: (data['states'] as List<dynamic>?)
          ?.map((e) => State.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'flag': flag,
        'states': states?.map((e) => e.toMap()).toList(),
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
        states: states?.map((state) => state.toStatesDto()).toList());
  }
}
