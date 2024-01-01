import 'dart:convert';

import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/data/api/user.dart';
import 'package:hatly/domain/models/trips_dto.dart';

class Trip {
  int? id;
  String? origin;
  String? destination;
  int? available;
  String? note;
  String? addressMeeting;
  DateTime? departDate;
  String? notNeed;
  User? user;
  List<Shipment>? shipments;

  Trip({
    this.id,
    this.origin,
    this.destination,
    this.available,
    this.note,
    this.addressMeeting,
    this.departDate,
    this.notNeed,
    this.user,
    this.shipments,
  });

  factory Trip.fromMap(Map<String, dynamic> data) => Trip(
        id: data['id'] as int?,
        origin: data['origin'] as String?,
        destination: data['destination'] as String?,
        available: data['available'] as int?,
        note: data['note'] as String?,
        addressMeeting: data['addressMeeting'] as String?,
        departDate: data['DepartDate'] == null
            ? null
            : DateTime.parse(data['DepartDate'] as String),
        notNeed: data['notNeed'] as String?,
        user: data['user'] == null
            ? null
            : User.fromMap(data['user'] as Map<String, dynamic>),
        shipments: (data['shipments'] as List<dynamic>?)
            ?.map((e) => Shipment.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'origin': origin,
        'destination': destination,
        'available': available,
        'note': note,
        'addressMeeting': addressMeeting,
        'DepartDate': departDate?.toIso8601String(),
        'notNeed': notNeed,
        'user': user?.toMap(),
        'shipments': shipments,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Trip].
  factory Trip.fromJson(String data) {
    return Trip.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Trip] to a JSON string.
  String toJson() => json.encode(toMap());

  TripsDto toTripsDto() {
    return TripsDto(
        id: id,
        origin: origin,
        destination: destination,
        available: available,
        note: note,
        notNeed: notNeed,
        addressMeeting: addressMeeting,
        departDate: departDate,
        user: user?.toUserDto(),
        shipments:
            shipments?.map((shipment) => shipment.toShipmentDto()).toList());
  }
}
