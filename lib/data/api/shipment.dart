import 'dart:convert';

import 'package:hatly/data/api/count.dart';
import 'package:hatly/data/api/item.dart';
import 'package:hatly/data/api/user.dart';

import '../../../domain/models/shipment_dto.dart';

class Shipment {
  String? id;
  User? user;
  String? title;
  dynamic trip;
  String? notes;
  double? wight;
  String? from, fromCity, toCity;
  String? to;
  double? totalPrice;
  double? reward;
  DateTime? expectedDate;
  DateTime? createdAt;

  List<Item>? items;
  Count? count;

  Shipment(
      {this.id,
      this.user,
      this.title,
      this.trip,
      this.createdAt,
      this.notes,
      this.fromCity,
      this.toCity,
      this.wight,
      this.from,
      this.to,
      this.totalPrice,
      this.reward,
      this.expectedDate,
      this.items,
      this.count});

  factory Shipment.fromMap(Map<String, dynamic> data) => Shipment(
        id: data['id'] as String?,
        user: data['user'] == null
            ? null
            : User.fromMap(data['user'] as Map<String, dynamic>),
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
            ?.map((e) => Item.fromMap(e as Map<String, dynamic>))
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
      fromCity: fromCity,
      createdAt: createdAt,
      toCity: toCity,
      to: to,
      notes: notes,
      totalPrice: totalPrice,
      reward: reward,
      expectedDate: expectedDate,
      items: items?.map((item) => item.toItemDto()).toList(),
      count: count,
    );
  }
}
