import 'dart:convert';

import 'package:hatly/data/api/shipments/item.dart';
import 'package:hatly/data/api/shipments/user.dart';

import '../../../domain/models/shipment_dto.dart';

class Shipment {
  int? id;
  User? user;
  String? title;
  dynamic trip;
  double? wight;
  String? from;
  String? to;
  double? totalPrice;
  double? reward;
  DateTime? expectedDate;
  List<Item>? items;

  Shipment({
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

  factory Shipment.fromMap(Map<String, dynamic> data) => Shipment(
        id: data['id'] as int?,
        user: data['user'] == null
            ? null
            : User.fromMap(data['user'] as Map<String, dynamic>),
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
            ?.map((e) => Item.fromMap(e as Map<String, dynamic>))
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

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Shipment].
  factory Shipment.fromJson(String data) {
    return Shipment.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Shipment] to a JSON string.
  String toJson() => json.encode(toMap());
  ShipmentDto toShipmentDto() {
    return ShipmentDto(
        id: id,
        user: user?.toUserDto(),
        title: title,
        trip: trip,
        wight: wight,
        from: from,
        to: to,
        totalPrice: totalPrice,
        reward: reward,
        expectedDate: expectedDate,
        items: items?.map((item) => item.toItemDto()).toList());
  }
}
