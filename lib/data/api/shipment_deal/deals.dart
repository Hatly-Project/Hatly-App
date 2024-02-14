import 'dart:convert';

class Deals {
  int? tripId;
  double? reward, hatlyFees, paymentFees;

  Deals({this.tripId, this.reward, this.hatlyFees, this.paymentFees});

  factory Deals.fromMap(Map<String, dynamic> data) => Deals(
        tripId: data['tripId'] as int?,
        reward: (data['reward'] as num?)?.toDouble(),
        hatlyFees: (data['fees'] as num?)?.toDouble(),
        paymentFees: (data['paymentFees'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'tripId': tripId,
        'reward': reward,
        'fees': hatlyFees,
        'paymentFees': paymentFees,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Deals].
  factory Deals.fromJson(String data) {
    return Deals.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Deals] to a JSON string.
  String toJson() => json.encode(toMap());
}
