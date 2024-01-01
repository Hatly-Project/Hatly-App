import 'dart:convert';

import 'package:hatly/data/api/trip.dart';
import 'package:hatly/domain/models/create_trip_response_dto.dart';

class CreateTripResponse {
  bool? status;
  Trip? trip;
  String? message;

  CreateTripResponse({this.status, this.trip, this.message});

  factory CreateTripResponse.fromMap(Map<String, dynamic> data) {
    return CreateTripResponse(
      status: data['status'] as bool?,
      message: data['message'] as String?,
      trip: data['trip'] == null
          ? null
          : Trip.fromMap(data['trip'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'trip': trip?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CreateTripResponse].
  factory CreateTripResponse.fromJson(String data) {
    return CreateTripResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CreateTripResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  CreateTripResponseDto toCreateTripResponseDto() {
    return CreateTripResponseDto(
        status: status, message: message, trip: trip?.toTripsDto());
  }
}
