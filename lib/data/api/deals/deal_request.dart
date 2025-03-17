import 'dart:convert';

class DealRequest {
  String? shipmentId, tripId;
  double? reward, hatlyFees, paymentFees;

  DealRequest(
      {this.shipmentId,
      this.tripId,
      this.reward,
      this.hatlyFees,
      this.paymentFees});

  factory DealRequest.fromMap(Map<String, dynamic> data) => DealRequest(
        shipmentId: data['shipmentId'] as String?,
        tripId: data['tripId'] as String?,
        reward: (data['offer'] as num?)?.toDouble(),
        hatlyFees: (data['fees'] as num?)?.toDouble(),
        paymentFees: (data['paymentFees'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'shipmentId': shipmentId,
        'tripId': tripId,
        'reward': reward,
        'fees': hatlyFees,
        'paymentFees': paymentFees,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DealRequest].
  factory DealRequest.fromJson(String data) {
    return DealRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DealRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
