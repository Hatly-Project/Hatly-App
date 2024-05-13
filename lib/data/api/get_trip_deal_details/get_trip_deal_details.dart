import 'dart:convert';

import 'package:hatly/domain/models/get_trip_deal_details_response_dto.dart';

import '../trips/my_trip_deals_response/deal.dart';

class GetTripDealDetailsResponse {
  Deal? deal;
  bool? status;
  String? message;
  GetTripDealDetailsResponse({this.deal, this.status, this.message});

  factory GetTripDealDetailsResponse.fromMap(Map<String, dynamic> data) {
    return GetTripDealDetailsResponse(
      deal: data['deal'] == null
          ? null
          : Deal.fromMap(data['deal'] as Map<String, dynamic>),
      status: data['status'] as bool?,
      message: data['message'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'deal': deal?.toMap(),
        'status': status,
        'message': message,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GetTripDealDetailsResponse].
  factory GetTripDealDetailsResponse.fromJson(String data) {
    return GetTripDealDetailsResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GetTripDealDetailsResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  GetTripDealDetailsResponseDto toDto() {
    return GetTripDealDetailsResponseDto(
        deal: deal?.toDto(), status: status, message: message);
  }
}
