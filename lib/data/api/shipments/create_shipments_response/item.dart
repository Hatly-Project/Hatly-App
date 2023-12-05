import 'dart:convert';

import 'package:hatly/domain/models/item_dto.dart';

class Item {
  int? id;
  double? price;
  double? weight;

  String? photo;
  String? link;
  String? name;

  int? shipmentId;

  Item(
      {this.id,
      this.price,
      this.photo,
      this.link,
      this.shipmentId,
      this.name,
      this.weight});

  factory Item.fromMap(Map<String, dynamic> data) => Item(
        id: data['id'] as int?,
        price: (data['price'] as num?)?.toDouble(),
        weight: (data['itemWeight'] as num?)?.toDouble(),
        photo: data['photo'] as String?,
        link: data['link'] as String?,
        name: data['name'] as String?,
        shipmentId: data['shipmentId'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'price': price,
        'itemWeight': weight,
        'photo': photo,
        'link': link,
        'name': name,
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
    return ItemDto(price: price, photo: photo, link: link, weight: weight);
  }
}
