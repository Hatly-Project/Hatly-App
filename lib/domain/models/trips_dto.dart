import 'dart:convert';

import 'package:hatly/data/api/trip.dart';
import 'package:hatly/domain/models/book_info_dto.dart';
import 'package:hatly/domain/models/items_not_allowed_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/user_model.dart';

class TripsDto {
  int? id;
  String? origin, originCity;
  String? destination, destinationCity;
  int? available;
  int? consumed;
  String? note;
  String? addressMeeting;
  DateTime? departDate;
  DateTime? createdAt;
  BookInfoDto? bookInfo;
  UserDto? user;
  List<ShipmentDto>? shipmentDto;
  List<ItemsNotAllowedDto>? itemsNotAllowed;

  TripsDto({
    this.id,
    this.origin,
    this.destination,
    this.originCity,
    this.destinationCity,
    this.available,
    this.consumed,
    this.note,
    this.addressMeeting,
    this.departDate,
    this.createdAt,
    this.bookInfo,
    this.user,
    this.shipmentDto,
    this.itemsNotAllowed,
  });

  factory TripsDto.fromMap(Map<String, dynamic> data) => TripsDto(
        id: data['id'] as int?,
        origin: data['origin'] as String?,
        destination: data['destination'] as String?,
        originCity: data['originCity'] as String?,
        destinationCity: data['destinationCity'] as String?,
        available: data['available'] as int?,
        consumed: data['consumed'] as int?,
        note: data['note'] as String?,
        user: data['user'] == null
            ? null
            : UserDto.fromMap(data['user'] as Map<String, dynamic>),
        addressMeeting: data['addressMeeting'] as String?,
        departDate: data['departDate'] == null
            ? null
            : DateTime.parse(data['departDate'] as String),
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        bookInfo: data['bookInfo'] == null
            ? null
            : BookInfoDto.fromMap(data['bookInfo'] as Map<String, dynamic>),
        itemsNotAllowed: (data['itemsNotAllowed'] as List<dynamic>?)
            ?.map((e) => ItemsNotAllowedDto.fromMap(e as Map<String, dynamic>))
            .toList(),
        shipmentDto: (data['itemsNotAllowed'] as List<dynamic>?)
            ?.map((e) => ShipmentDto.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'origin': origin,
        'destination': destination,
        'originCity': originCity,
        'destinationCity': destinationCity,
        'available': available,
        'consumed': consumed,
        'note': note,
        'user': user,
        'addressMeeting': addressMeeting,
        'departDate': departDate?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'bookInfo': bookInfo?.toMap(),
        'itemsNotAllowed': itemsNotAllowed?.map((e) => e.toMap()).toList(),
        'shipments': shipmentDto?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Trip].
  factory TripsDto.fromJson(String data) {
    return TripsDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Trip] to a JSON string.
  String toJson() => json.encode(toMap());
}
