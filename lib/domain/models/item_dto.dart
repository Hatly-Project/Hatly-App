import 'dart:convert';

import 'package:hatly/data/api/item.dart';
import 'package:hatly/data/api/photo.dart';
import 'package:hatly/domain/models/photo_dto.dart';

class ItemDto {
  double? price;
  double? weight;
  int? quantity;
  List<PhotoDto>? photos;
  String? link;
  String? name;
  int? id;
  int? shipmentId;
  ItemDto(
      {this.price,
      this.photos,
      this.link,
      this.id,
      this.quantity = 1,
      this.shipmentId,
      this.name,
      this.weight});

  Item toItem() {
    return Item(
        photos: photos?.map((photo) => photo.toPhoto()).toList(),
        price: price,
        link: link,
        name: name,
        weight: weight,
        quantity: quantity);
  }

  factory ItemDto.fromMap(Map<String, dynamic> data) => ItemDto(
        id: data['id'] as int?,
        quantity: data['quantity'] as int?,
        name: data['name'] as String?,
        price: (data['price'] as num?)?.toDouble(),
        photos: (data['photos'] as List<dynamic>?)
            ?.map((e) => PhotoDto.fromMap(e as Map<String, dynamic>))
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
