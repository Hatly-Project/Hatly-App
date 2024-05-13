import 'dart:convert';

import 'package:hatly/domain/models/trip_deal_dto.dart';

class GetTripDealDetailsResponseDto {
  TripDealDto? deal;
  bool? status;
  String? message;
  GetTripDealDetailsResponseDto({this.deal, this.status, this.message});

  factory GetTripDealDetailsResponseDto.fromMap(Map<String, dynamic> data) {
    return GetTripDealDetailsResponseDto(
      deal: data['deal'] == null
          ? null
          : TripDealDto.fromMap(data['deal'] as Map<String, dynamic>),
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
  /// Parses the string and returns the resulting Json object as [GetTripDealDetailsResponseDto].
  factory GetTripDealDetailsResponseDto.fromJson(String data) {
    return GetTripDealDetailsResponseDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GetTripDealDetailsResponseDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
