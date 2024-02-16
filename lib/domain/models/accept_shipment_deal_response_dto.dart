import 'dart:convert';

import 'package:hatly/data/api/shipmentDeal.dart';
import 'package:hatly/domain/models/deal_dto.dart';

class AcceptShipmentDealResponseDto {
  bool? status;
  DealDto? deal;
  String? clientSecret;
  String? paymentIntentId;
  String? message;

  AcceptShipmentDealResponseDto(
      {this.status,
      this.deal,
      this.clientSecret,
      this.paymentIntentId,
      this.message});

  factory AcceptShipmentDealResponseDto.fromMap(Map<String, dynamic> data) {
    return AcceptShipmentDealResponseDto(
      status: data['status'] as bool?,
      deal: data['deal'] == null
          ? null
          : DealDto.fromMap(data['deal'] as Map<String, dynamic>),
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
  /// Parses the string and returns the resulting Json object as [AcceptShipmentDealResponseDto].
  factory AcceptShipmentDealResponseDto.fromJson(String data) {
    return AcceptShipmentDealResponseDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AcceptShipmentDealResponseDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
