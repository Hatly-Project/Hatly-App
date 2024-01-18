import 'dart:convert';

class StateDto {
  String? name;

  StateDto({this.name});

  factory StateDto.fromMap(Map<String, dynamic> data) => StateDto(
        name: data['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [StateDto].
  factory StateDto.fromJson(String data) {
    return StateDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [StateDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
