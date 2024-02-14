import 'dart:convert';

import 'package:hatly/data/api/shipmentDeal.dart';

class GetMyShipmentDealDetailsResponseDto {
  Deal? deal;
  bool? status;
  String? message;

  GetMyShipmentDealDetailsResponseDto({this.deal, this.status, this.message});

  factory GetMyShipmentDealDetailsResponseDto.fromMap(
      Map<String, dynamic> data) {
    return GetMyShipmentDealDetailsResponseDto(
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
  /// Parses the string and returns the resulting Json object as [GetMyShipmentDealDetailsResponseDto].
  factory GetMyShipmentDealDetailsResponseDto.fromJson(String data) {
    return GetMyShipmentDealDetailsResponseDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GetMyShipmentDealDetailsResponseDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
