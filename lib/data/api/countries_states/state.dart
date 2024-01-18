import 'dart:convert';

import 'package:hatly/domain/models/state_dto.dart';

class State {
  String? name;

  State({this.name});

  factory State.fromMap(Map<String, dynamic> data) => State(
        name: data['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [State].
  factory State.fromJson(String data) {
    return State.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [State] to a JSON string.
  String toJson() => json.encode(toMap());

  StateDto toStatesDto() {
    return StateDto(name: name);
  }
}
