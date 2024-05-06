import 'dart:convert';

import 'package:hatly/data/api/trips/my_trip_deals_response/deal.dart';
import 'package:hatly/domain/models/my_trip_deals_response_dto.dart';

class MyTripDealsResponse {
  bool? status;
  String? message;
  List<Deal>? deals;

  MyTripDealsResponse({this.status, this.deals, this.message});

  factory MyTripDealsResponse.fromMap(Map<String, dynamic> data) {
    return MyTripDealsResponse(
      status: data['status'] as bool?,
      message: data['message'] as String?,
      deals: (data['deals'] as List<dynamic>?)
          ?.map((e) => Deal.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'deals': deals?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MyTripDealsResponse].
  factory MyTripDealsResponse.fromJson(String data) {
    return MyTripDealsResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MyTripDealsResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  MyTripDealsResponseDto toDto() {
    return MyTripDealsResponseDto(
        status: status,
        deals: deals?.map((deal) => deal.toDto()).toList(),
        message: message);
  }
}
