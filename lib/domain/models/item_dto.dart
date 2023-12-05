import 'dart:convert';

import 'package:hatly/data/api/shipments/create_shipment_request/item.dart';

class ItemDto {
  double? price;
  double? weight;

  String? photo;
  String? link;
  String? name;
  int? id;
  int? shipmentId;
  ItemDto(
      {this.price,
      this.photo,
      this.link,
      this.id,
      this.shipmentId,
      this.name,
      this.weight});

  Item toItem() {
    return Item(
        photo: photo, price: price, link: link, name: name, weight: weight);
  }

  factory ItemDto.fromMap(Map<String, dynamic> data) => ItemDto(
        id: data['id'] as int?,
        name: data['name'] as String?,
        price: (data['price'] as num?)?.toDouble(),
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
        'shipmentId': shipmentId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Item].
  factory ItemDto.fromJson(String data) {
    return ItemDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Item] to a JSON string.
  String toJson() => json.encode(toMap());
}
