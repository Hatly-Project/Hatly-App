import 'dart:convert';

import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/user_model.dart';

class ShipmentDto {
  int? id;
  UserDto? user;
  String? title;
  dynamic trip;
  double? wight;
  String? from;
  String? to;
  double? totalPrice;
  double? reward;
  DateTime? expectedDate;
  List<ItemDto>? items;

  ShipmentDto({
    this.id,
    this.user,
    this.title,
    this.trip,
    this.wight,
    this.from,
    this.to,
    this.totalPrice,
    this.reward,
    this.expectedDate,
    this.items,
  });

  factory ShipmentDto.fromMap(Map<String, dynamic> data) => ShipmentDto(
        id: data['id'] as int?,
        user: data['user'] == null
            ? null
            : UserDto.fromMap(data['user'] as Map<String, dynamic>),
        title: data['title'] as String?,
        trip: data['trip'] as dynamic,
        wight: (data['wight'] as num?)?.toDouble(),
        from: data['from'] as String?,
        to: data['to'] as String?,
        totalPrice: (data['total_price'] as num?)?.toDouble(),
        reward: (data['reward'] as num?)?.toDouble(),
        expectedDate: data['expectedDate'] == null
            ? null
            : DateTime.parse(data['expectedDate'] as String),
        items: (data['items'] as List<dynamic>?)
            ?.map((e) => ItemDto.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user': user?.toMap(),
        'title': title,
        'trip': trip,
        'wight': wight,
        'from': from,
        'to': to,
        'total_price': totalPrice,
        'reward': reward,
        'expectedDate': expectedDate?.toIso8601String(),
        'items': items?.map((e) => e.toMap()).toList(),
      };

  String toJson() => json.encode(toMap());

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Shipment].
  factory ShipmentDto.fromJson(String data) {
    return ShipmentDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }
}
