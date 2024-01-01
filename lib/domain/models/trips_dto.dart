import 'dart:convert';

import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/user_model.dart';

class TripsDto {
  int? id;
  String? origin;
  String? destination;
  int? available;
  int? consumed;
  String? note;
  String? addressMeeting;
  DateTime? departDate;
  String? notNeed;
  List<ShipmentDto>? shipments;
  UserDto? user;

  TripsDto({
    this.id,
    this.origin,
    this.destination,
    this.available,
    this.consumed,
    this.note,
    this.addressMeeting,
    this.departDate,
    this.notNeed,
    this.shipments,
    this.user,
  });

  factory TripsDto.fromMap(Map<String, dynamic> data) => TripsDto(
        id: data['id'] as int?,
        origin: data['origin'] as String?,
        destination: data['destination'] as String?,
        available: data['available'] as int?,
        consumed: data['consumed'] as int?,
        note: data['note'] as String?,
        addressMeeting: data['addressMeeting'] as String?,
        departDate: data['DepartDate'] == null
            ? null
            : DateTime.parse(data['DepartDate'] as String),
        notNeed: data['notNeed'] as String?,
        shipments: data['shipments'] as List<ShipmentDto>?,
        user: data['user'] == null
            ? null
            : UserDto.fromMap(data['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'origin': origin,
        'destination': destination,
        'available': available,
        'consumed': consumed,
        'note': note,
        'addressMeeting': addressMeeting,
        'DepartDate': departDate?.toIso8601String(),
        'notNeed': notNeed,
        'shipments': shipments,
        'user': user?.toMap(),
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
