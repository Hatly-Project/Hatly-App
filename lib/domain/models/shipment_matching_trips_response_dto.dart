import 'dart:convert';

import 'package:hatly/data/api/trip.dart';
import 'package:hatly/domain/models/trips_dto.dart';

class ShipmentMatchingTripsResponseDto {
  bool? status;
  String? message;
  List<TripsDto>? trips;

  ShipmentMatchingTripsResponseDto({this.status, this.trips, this.message});

  factory ShipmentMatchingTripsResponseDto.fromMap(Map<String, dynamic> data) {
    return ShipmentMatchingTripsResponseDto(
      status: data['status'] as bool?,
      message: data['message'] as String?,
      trips: (data['trips'] as List<dynamic>?)
          ?.map((e) => TripsDto.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'trips': trips?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ShipmentMatchingTripsResponseDto].
  factory ShipmentMatchingTripsResponseDto.fromJson(String data) {
    return ShipmentMatchingTripsResponseDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ShipmentMatchingTripsResponseDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
