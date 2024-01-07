import 'dart:convert';

import 'package:hatly/data/api/trip.dart';
import 'package:hatly/domain/models/trips_dto.dart';

class GetUserTripResponseDto {
  bool? status;
  String? message;
  List<TripsDto>? trips;

  GetUserTripResponseDto({this.status, this.trips, this.message});

  factory GetUserTripResponseDto.fromMap(Map<String, dynamic> data) {
    return GetUserTripResponseDto(
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
        'trips': trips?.map((trip) => trip.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GetUserTripResponseDto].
  factory GetUserTripResponseDto.fromJson(String data) {
    return GetUserTripResponseDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GetUserTripResponseDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
