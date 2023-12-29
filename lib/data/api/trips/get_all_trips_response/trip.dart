import 'dart:convert';

import 'package:hatly/data/api/shipments/shipment.dart';
import 'package:hatly/data/api/shipments/user.dart';
import 'package:hatly/domain/models/trips_dto.dart';

class Trip {
  int? id;
  String? origin;
  String? destination;
  int? totalWight;
  int? available;
  String? note;
  String? addressMeeting;
  DateTime? departDate;
  String? notNeed;
  List<Shipment>? shipments;
  User? user;

  Trip({
    this.id,
    this.origin,
    this.destination,
    this.totalWight,
    this.available,
    this.note,
    this.addressMeeting,
    this.departDate,
    this.notNeed,
    this.shipments,
    this.user,
  });

  factory Trip.fromMap(Map<String, dynamic> data) => Trip(
        id: data['id'] as int?,
        origin: data['origin'] as String?,
        destination: data['destination'] as String?,
        totalWight: data['total_wight'] as int?,
        available: data['available'] as int?,
        note: data['note'] as String?,
        addressMeeting: data['addressMeeting'] as String?,
        departDate: data['DepartDate'] == null
            ? null
            : DateTime.parse(data['DepartDate'] as String),
        notNeed: data['notNeed'] as String?,
        shipments: data['shipments'] as List<Shipment>?,
        user: data['user'] == null
            ? null
            : User.fromMap(data['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'origin': origin,
        'destination': destination,
        'total_wight': totalWight,
        'available': available,
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
        totalWight: totalWight,
        available: available,
        note: note,
        addressMeeting: addressMeeting,
        departDate: departDate,
        notNeed: notNeed,
        shipments:
            shipments?.map((shipment) => shipment.toShipmentDto()).toList(),
        user: user?.toUserDto());
  }
}
