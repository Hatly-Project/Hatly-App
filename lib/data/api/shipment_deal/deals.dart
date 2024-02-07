import 'dart:convert';

class Deals {
  int? tripId;
  double? reward;

  Deals({this.tripId, this.reward});

  factory Deals.fromMap(Map<String, dynamic> data) => Deals(
        tripId: data['tripId'] as int?,
        reward: (data['reward'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'tripId': tripId,
        'reward': reward,
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
