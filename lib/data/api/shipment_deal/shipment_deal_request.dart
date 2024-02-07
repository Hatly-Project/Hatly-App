import 'dart:convert';

import 'deals.dart';

class ShipmentDealRequest {
  Deals? deals;

  ShipmentDealRequest({this.deals});

  factory ShipmentDealRequest.fromMap(Map<String, dynamic> data) {
    return ShipmentDealRequest(
      deals: data['deals'] == null
          ? null
          : Deals.fromMap(data['deals'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'deals': deals?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ShipmentDealRequest].
  factory ShipmentDealRequest.fromJson(String data) {
    return ShipmentDealRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ShipmentDealRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
