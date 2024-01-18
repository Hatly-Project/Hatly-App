import 'dart:convert';

import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/domain/models/trip_deal_request_dto.dart';

class TripDealRequest {
  List<Shipment>? shipments;
  double? reward;

  TripDealRequest({this.shipments, this.reward});

  factory TripDealRequest.fromMap(Map<String, dynamic> data) {
    return TripDealRequest(
      shipments: (data['shipments'] as List<dynamic>?)
          ?.map((e) => Shipment.fromMap(e as Map<String, dynamic>))
          .toList(),
      reward: (data['reward'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'shipments': shipments?.map((e) => e.toMap()).toList(),
        'reward': reward,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TripDealRequest].
  factory TripDealRequest.fromJson(String data) {
    return TripDealRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TripDealRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  TripDealRequestDto toTripDealRequestDto() {
    return TripDealRequestDto(
        shipments:
            shipments?.map((shipment) => shipment.toShipmentDto()).toList(),
        reward: reward);
  }
}
