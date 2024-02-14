import 'dart:convert';

import 'package:hatly/data/api/count.dart';
import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/user_model.dart';

class ShipmentDto {
  int? id;
  UserDto? user;
  String? title;
  dynamic trip;
  String? notes;
  double? wight;
  String? from, fromCity, toCity;
  String? to;
  double? totalPrice;
  double? reward;
  DateTime? expectedDate, createdAt;
  List<ItemDto>? items;
  Count? count;

  ShipmentDto(
      {this.id,
      this.user,
      this.title,
      this.trip,
      this.wight,
      this.from,
      this.fromCity,
      this.toCity,
      this.createdAt,
      this.to,
      this.totalPrice,
      this.reward,
      this.expectedDate,
      this.items,
      this.notes,
      this.count});

  factory ShipmentDto.fromMap(Map<String, dynamic> data) => ShipmentDto(
        id: data['id'] as int?,
        user: data['user'] == null
            ? null
            : UserDto.fromMap(data['user'] as Map<String, dynamic>),
        title: data['title'] as String?,
        trip: data['trip'] as dynamic,
        wight: (data['wight'] as num?)?.toDouble(),
        from: data['from'] as String?,
        fromCity: data['fromCity'] as String?,
        toCity: data['toCity'] as String?,
        notes: data['note'] as String?,
        to: data['to'] as String?,
        totalPrice: (data['total_price'] as num?)?.toDouble(),
        reward: (data['reward'] as num?)?.toDouble(),
        expectedDate: data['expectedDate'] == null
            ? null
            : DateTime.parse(data['expectedDate'] as String),
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        items: (data['items'] as List<dynamic>?)
            ?.map((e) => ItemDto.fromMap(e as Map<String, dynamic>))
            .toList(),
        count: data['_count'] == null
            ? null
            : Count.fromMap(data['_count'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user': user?.toMap(),
        'title': title,
        'trip': trip,
        'wight': wight,
        'note': notes,
        'from': from,
        'fromCity': fromCity,
        'toCity': toCity,
        'to': to,
        'total_price': totalPrice,
        'reward': reward,
        'expectedDate': expectedDate?.toIso8601String(),
        'createdDate': createdAt?.toIso8601String(),
        'items': items?.map((e) => e.toMap()).toList(),
        '_count': count?.toMap(),
      };

  String toJson() => json.encode(toMap());

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Shipment].
  factory ShipmentDto.fromJson(String data) {
    return ShipmentDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  Shipment toShipment() {
    return Shipment(
        id: id,
        title: title,
        notes: notes,
        wight: wight,
        from: from,
        to: to,
        fromCity: fromCity,
        toCity: toCity,
        totalPrice: totalPrice,
        createdAt: createdAt,
        reward: reward,
        expectedDate: expectedDate,
        items: items?.map((item) => item.toItem()).toList(),
        count: count,
        user: user?.toUser());
  }
}
