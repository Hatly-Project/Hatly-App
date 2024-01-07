import 'dart:convert';

import 'package:hatly/domain/models/items_not_allowed_dto.dart';

class ItemsNotAllowed {
  String? name;

  ItemsNotAllowed({this.name});

  factory ItemsNotAllowed.fromMap(Map<String, dynamic> data) {
    return ItemsNotAllowed(
      name: data['name'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ItemsNotAllowed].
  factory ItemsNotAllowed.fromJson(String data) {
    return ItemsNotAllowed.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ItemsNotAllowed] to a JSON string.
  String toJson() => json.encode(toMap());

  ItemsNotAllowedDto toItemsNotAllowedDto() {
    return ItemsNotAllowedDto(name: name);
  }
}
