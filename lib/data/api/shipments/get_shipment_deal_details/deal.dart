import 'dart:convert';

import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/data/api/trips/my_trip_deals_response/shopper.dart';
import 'package:hatly/domain/models/ship_deal_details_dto.dart';

import 'payments.dart';

class Deal {
  int? id;
  int? counterReward;
  int? finalReward;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? shipmentId;
  int? tripId;
  int? shopperUserId;
  int? travelerUserId;
  String? creatorEmail;
  String? type;
  double? fees;
  double? paymentFees;
  String? dealStatus;
  Shopper? shopper;
  Shipment? shipment;
  Payments? payments;

  Deal({
    this.id,
    this.counterReward,
    this.finalReward,
    this.createdAt,
    this.updatedAt,
    this.shipmentId,
    this.tripId,
    this.shopperUserId,
    this.travelerUserId,
    this.creatorEmail,
    this.type,
    this.fees,
    this.paymentFees,
    this.dealStatus,
    this.shopper,
    this.shipment,
    this.payments,
  });

  factory Deal.fromMap(Map<String, dynamic> data) => Deal(
        id: data['id'] as int?,
        counterReward: data['counterReward'] as int?,
        finalReward: data['finalReward'] as int?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        shipmentId: data['shipmentId'] as int?,
        tripId: data['tripId'] as int?,
        shopperUserId: data['shopperUserId'] as int?,
        travelerUserId: data['travelerUserId'] as int?,
        creatorEmail: data['creatorEmail'] as String?,
        type: data['type'] as String?,
        fees: (data['fees'] as num?)?.toDouble(),
        paymentFees: (data['paymentFees'] as num?)?.toDouble(),
        dealStatus: data['dealStatus'] as String?,
        shopper: data['shopper'] == null
            ? null
            : Shopper.fromMap(data['shopper'] as Map<String, dynamic>),
        shipment: data['shipment'] == null
            ? null
            : Shipment.fromMap(data['shipment'] as Map<String, dynamic>),
        payments: data['payments'] == null
            ? null
            : Payments.fromMap(data['payments'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'counterReward': counterReward,
        'finalReward': finalReward,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'shipmentId': shipmentId,
        'tripId': tripId,
        'shopperUserId': shopperUserId,
        'travelerUserId': travelerUserId,
        'creatorEmail': creatorEmail,
        'type': type,
        'fees': fees,
        'paymentFees': paymentFees,
        'dealStatus': dealStatus,
        'shopper': shopper?.toMap(),
        'shipment': shipment?.toMap(),
        'payments': payments?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Deal].
  factory Deal.fromJson(String data) {
    return Deal.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Deal] to a JSON string.
  String toJson() => json.encode(toMap());

  ShipmentDealDetailsDto toDto() {
    return ShipmentDealDetailsDto(
        id: id,
        counterReward: counterReward,
        finalReward: finalReward,
        createdAt: createdAt,
        updatedAt: updatedAt,
        shipmentId: shipmentId,
        tripId: tripId,
        shopperUserId: shopperUserId,
        travelerUserId: travelerUserId,
        creatorEmail: creatorEmail,
        type: type,
        fees: fees,
        paymentFees: paymentFees,
        dealStatus: dealStatus,
        shopper: shopper,
        shipment: shipment,
        payments: payments?.toDto());
  }
}
