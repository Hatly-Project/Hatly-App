import 'dart:convert';

import 'package:hatly/data/api/trip.dart';
import 'package:hatly/domain/models/shipment_matching_trips_response_dto.dart';

class ShipmentMatchingTripsResponse {
  bool? status;
  String? message;
  List<Trip>? trips;

  ShipmentMatchingTripsResponse({this.status, this.trips, this.message});

  factory ShipmentMatchingTripsResponse.fromMap(Map<String, dynamic> data) {
    return ShipmentMatchingTripsResponse(
      status: data['status'] as bool?,
      message: data['message'] as String?,
      trips: (data['trips'] as List<dynamic>?)
          ?.map((e) => Trip.fromMap(e as Map<String, dynamic>))
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
  /// Parses the string and returns the resulting Json object as [ShipmentMatchingTripsResponse].
  factory ShipmentMatchingTripsResponse.fromJson(String data) {
    return ShipmentMatchingTripsResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ShipmentMatchingTripsResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  ShipmentMatchingTripsResponseDto toDto() {
    return ShipmentMatchingTripsResponseDto(
        status: status,
        trips: trips?.map((trip) => trip.toTripsDto()).toList());
  }
}
