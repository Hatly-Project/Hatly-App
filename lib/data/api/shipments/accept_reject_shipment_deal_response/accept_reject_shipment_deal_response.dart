import 'dart:convert';

import 'package:hatly/data/api/shipmentDeal.dart';
import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';

class AcceptOrRejectShipmentDealResponse {
  bool? status;
  String? message;
  Deal? deal;
  String? clientSecret;
  String? paymentIntentId;

  AcceptOrRejectShipmentDealResponse({
    this.status,
    this.deal,
    this.message,
    this.clientSecret,
    this.paymentIntentId,
  });

  factory AcceptOrRejectShipmentDealResponse.fromMap(
      Map<String, dynamic> data) {
    return AcceptOrRejectShipmentDealResponse(
      status: data['status'] as bool?,
      deal: data['deal'] == null
          ? null
          : Deal.fromMap(data['deal'] as Map<String, dynamic>),
      clientSecret: data['clientSecret'] as String?,
      message: data['message'] as String?,
      paymentIntentId: data['paymentIntentId'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'deal': deal?.toMap(),
        'clientSecret': clientSecret,
        'message': message,
        'paymentIntentId': paymentIntentId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AcceptOrRejectShipmentDealResponse].
  factory AcceptOrRejectShipmentDealResponse.fromJson(String data) {
    return AcceptOrRejectShipmentDealResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AcceptOrRejectShipmentDealResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  AcceptOrRejectShipmentDealResponseDto toResponseDto() {
    return AcceptOrRejectShipmentDealResponseDto(
        status: status,
        message: message,
        clientSecret: clientSecret,
        paymentIntentId: paymentIntentId,
        deal: deal?.toDealDto());
  }
}
