import 'dart:convert';

class UserShipment {
  bool? status;
  List<dynamic>? shipments;

  UserShipment({this.status, this.shipments});

  factory UserShipment.fromMap(Map<String, dynamic> data) => UserShipment(
        status: data['status'] as bool?,
        shipments: data['shipments'] as List<dynamic>?,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'shipments': shipments,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserShipment].
  factory UserShipment.fromJson(String data) {
    return UserShipment.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserShipment] to a JSON string.
  String toJson() => json.encode(toMap());

  UserShipment copyWith({
    bool? status,
    List<dynamic>? shipments,
  }) {
    return UserShipment(
      status: status ?? this.status,
      shipments: shipments ?? this.shipments,
    );
  }
}
