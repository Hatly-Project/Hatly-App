import 'dart:convert';

import 'package:hatly/domain/models/items_not_allowed_dto.dart';

class ItemsNotAllowed {
  int? id;
  String? name;
  int? tripId;

  ItemsNotAllowed({this.id, this.name, this.tripId});

  factory ItemsNotAllowed.fromMap(Map<String, dynamic> data) {
    return ItemsNotAllowed(
      id: data['id'] as int?,
      name: data['name'] as String?,
      tripId: data['tripId'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'tripId': tripId,
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
    return ItemsNotAllowedDto(name: name, id: id, tripId: tripId);
  }
}
