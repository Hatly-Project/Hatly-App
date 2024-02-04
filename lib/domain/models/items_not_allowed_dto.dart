import 'dart:convert';

import 'package:hatly/data/api/items_not_allowed.dart';

class ItemsNotAllowedDto {
  int? id;
  String? name;
  int? tripId;

  ItemsNotAllowedDto({this.name, this.id, this.tripId});

  factory ItemsNotAllowedDto.fromMap(Map<String, dynamic> data) {
    return ItemsNotAllowedDto(
      name: data['name'] as String?,
      id: data['id'] as int?,
      tripId: data['tripId'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
        'tripId': tripId,
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
    return ItemsNotAllowed(name: name, id: id, tripId: tripId);
  }
}
