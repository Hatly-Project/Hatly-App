import 'dart:convert';

import 'package:hatly/data/api/photo.dart';
import 'package:hatly/domain/models/item_dto.dart';

class Item {
  int? id;
  String? name;
  int? quantity;
  double? price;
  double? weight;
  List<Photo>? photos;
  String? link;
  int? shipmentId;

  Item({
    this.id,
    this.name,
    this.price,
    this.photos,
    this.link,
    this.weight,
    this.quantity = 1,
    this.shipmentId,
  });

  factory Item.fromMap(Map<String, dynamic> data) => Item(
        id: data['id'] as int?,
        quantity: data['quantity'] as int?,
        name: data['name'] as String?,
        price: (data['price'] as num?)?.toDouble(),
        weight: (data['itemWeight'] as num?)?.toDouble(),
        photos: (data['photos'] as List<dynamic>?)
            ?.map((e) => Photo.fromMap(e as Map<String, dynamic>))
            .toList(),
        link: data['link'] as String?,
        shipmentId: data['shipmentId'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'quantity': quantity,
        'name': name,
        'price': price,
        'photos': photos?.map((e) => e.toMap()).toList(),
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
        photos: photos?.map((photo) => photo.tophotoDto()).toList(),
        link: link,
        quantity: quantity,
        id: id,
        shipmentId: shipmentId,
        name: name,
        weight: weight);
  }
}
