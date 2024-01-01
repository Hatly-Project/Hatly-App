import 'dart:convert';

import 'package:hatly/domain/models/item_dto.dart';

class Item {
  int? id;
  String? name;
  double? price;
  double? weight;
  String? photo;
  String? link;
  int? shipmentId;

  Item({
    this.id,
    this.name,
    this.price,
    this.photo,
    this.link,
    this.weight,
    this.shipmentId,
  });

  factory Item.fromMap(Map<String, dynamic> data) => Item(
        id: data['id'] as int?,
        name: data['name'] as String?,
        price: (data['price'] as num?)?.toDouble(),
        weight: (data['itemWeight'] as num?)?.toDouble(),
        photo: data['photo'] as String?,
        link: data['link'] as String?,
        shipmentId: data['shipmentId'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'price': price,
        'photo': photo,
        'link': link,
        'itemWeight': weight,
        'shipmentId': shipmentId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Item].
  factory Item.fromJson(String data) {
    return Item.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Item] to a JSON string.
  String toJson() => json.encode(toMap());

  ItemDto toItemDto() {
    return ItemDto(
        price: price,
        photo: photo,
        link: link,
        id: id,
        shipmentId: shipmentId,
        name: name,
        weight: weight);
  }
}
