import 'dart:convert';

import 'package:hatly/data/api/shipments/get_shipment_deal_details/deal.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';

class GetMyShipmentDealDetailsResponse {
  Deal? deal;
  bool? status;
  String? message;

  GetMyShipmentDealDetailsResponse({this.deal, this.status, this.message});

  factory GetMyShipmentDealDetailsResponse.fromMap(Map<String, dynamic> data) {
    return GetMyShipmentDealDetailsResponse(
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
  /// Parses the string and returns the resulting Json object as [GetMyShipmentDealDetailsResponse].
  factory GetMyShipmentDealDetailsResponse.fromJson(String data) {
    return GetMyShipmentDealDetailsResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GetMyShipmentDealDetailsResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  GetMyShipmentDealDetailsResponseDto toResponseDto() {
    return GetMyShipmentDealDetailsResponseDto(
      status: status,
      message: message,
      deal: deal?.toDto(),
    );
  }
}
