import 'dart:convert';

import 'package:hatly/domain/models/get_all_trips_response_dto.dart';

import '../../../trip.dart';

class GetAllTripsResponse {
  bool? status;
  List<Trip>? trips;
  String? message;
  int? totalPages, totalData;

  GetAllTripsResponse(
      {this.status, this.trips, this.message, this.totalPages, this.totalData});

  factory GetAllTripsResponse.fromMap(Map<String, dynamic> data) {
    return GetAllTripsResponse(
      status: data['status'] as bool?,
      message: data['message'] as String?,
      totalPages: data['totalPages'] as int?,
      totalData: data['totalData'] as int?,
      trips: (data['trips'] as List<dynamic>?)
          ?.map((e) => Trip.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'totalPages': totalPages,
        'totalData': totalData,
        'message': message,
        'trips': trips?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GetAllTripsResponse].
  factory GetAllTripsResponse.fromJson(String data) {
    return GetAllTripsResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GetAllTripsResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  GetAllTripsResponseDto toTripsResponseDto() {
    return GetAllTripsResponseDto(
        status: status,
        totalPages: totalPages,
        totalData: totalData,
        trips: trips?.map((trip) => trip.toTripsDto()).toList(),
        message: message);
  }
}
