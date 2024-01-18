import 'dart:convert';

import 'package:hatly/domain/models/state_dto.dart';

class CountriesStatesDto {
  String? name;
  String? error, msg;
  String? flag;
  List<StateDto>? states;

  CountriesStatesDto({this.name, this.flag, this.states, this.error, this.msg});

  factory CountriesStatesDto.fromMap(Map<String, dynamic> data) {
    return CountriesStatesDto(
      name: data['name'] as String?,
      error: data['error'] as String?,
      msg: data['msg'] as String?,
      flag: data['flag'] as String?,
      states: (data['states'] as List<dynamic>?)
          ?.map((e) => StateDto.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'error': error,
        'msg': msg,
        'flag': flag,
        'states': states?.map((e) => e.toMap()).toList(),
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
