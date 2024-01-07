import 'dart:convert';

import 'package:hatly/data/api/items_not_allowed.dart';

class ItemsNotAllowedDto {
  String? name;

  ItemsNotAllowedDto({this.name});

  factory ItemsNotAllowedDto.fromMap(Map<String, dynamic> data) {
    return ItemsNotAllowedDto(
      name: data['name'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ItemsNotAllowed].
  factory ItemsNotAllowedDto.fromJson(String data) {
    return ItemsNotAllowedDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ItemsNotAllowed] to a JSON string.
  String toJson() => json.encode(toMap());

  ItemsNotAllowed toItemsNotAllowed() {
    return ItemsNotAllowed(name: name);
  }
}
