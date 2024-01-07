import 'dart:convert';

import 'package:hatly/data/api/trip.dart';
import 'package:hatly/domain/models/get_user_trip_response_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';

class GetUserTripResponse {
  String? message;
  bool? status;
  List<Trip>? trips;

  GetUserTripResponse({this.status, this.trips, this.message});

  factory GetUserTripResponse.fromMap(Map<String, dynamic> data) {
    return GetUserTripResponse(
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
        'trips': trips?.map((trip) => trip.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GetUserTripResponse].
  factory GetUserTripResponse.fromJson(String data) {
    return GetUserTripResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GetUserTripResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  GetUserTripResponseDto toUserTripResponseDto() {
    return GetUserTripResponseDto(
        status: status,
        trips: trips?.map((trip) => trip.toTripsDto()).toList(),
        message: message);
  }
}
