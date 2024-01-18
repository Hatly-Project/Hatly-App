import 'dart:convert';

class Deals {
  int? shipmentId;
  double? reward;

  Deals({this.shipmentId, this.reward});

  factory Deals.fromMap(Map<String, dynamic> data) => Deals(
        shipmentId: data['shipmentId'] as int?,
        reward: (data['reward'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'shipmentId': shipmentId,
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
