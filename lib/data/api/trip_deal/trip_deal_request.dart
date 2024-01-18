import 'dart:convert';

import 'deals.dart';

class TripDealRequest {
  Deals? deals;

  TripDealRequest({this.deals});

  factory TripDealRequest.fromMap(Map<String, dynamic> data) {
    return TripDealRequest(
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
  /// Parses the string and returns the resulting Json object as [TripDealRequest].
  factory TripDealRequest.fromJson(String data) {
    return TripDealRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TripDealRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
