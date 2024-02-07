import 'dart:convert';

import 'package:hatly/domain/models/shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/trip_deal_response.dart';

class ShipmentDealResponse {
  bool? status;
  String? message;

  ShipmentDealResponse({this.status, this.message});

  factory ShipmentDealResponse.fromMap(Map<String, dynamic> data) {
    return ShipmentDealResponse(
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
  /// Parses the string and returns the resulting Json object as [ShipmentDealResponse].
  factory ShipmentDealResponse.fromJson(String data) {
    return ShipmentDealResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ShipmentDealResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  ShipmentDealResponseDto toShipmentDealResponseDto() {
    return ShipmentDealResponseDto(status: status, message: message);
  }
}
