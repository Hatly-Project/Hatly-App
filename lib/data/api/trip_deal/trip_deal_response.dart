import 'dart:convert';

import 'package:hatly/domain/models/trip_deal_response.dart';

class TripDealResponse {
  bool? status;
  String? message;

  TripDealResponse({this.status, this.message});

  factory TripDealResponse.fromMap(Map<String, dynamic> data) {
    return TripDealResponse(
      status: data['status'] as bool?,
      message: data['message'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TripDealResponse].
  factory TripDealResponse.fromJson(String data) {
    return TripDealResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TripDealResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  TripDealResponseDto toTripDealResponseDto() {
    return TripDealResponseDto(status: status, message: message);
  }
}
