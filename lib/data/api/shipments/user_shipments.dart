import 'dart:convert';

import 'package:hatly/data/api/shipments/create_shipments_response/shipment.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';

class UserShipmentsResponse {
  bool? status;
  List<Shipment>? shipments;
  String? message;

  UserShipmentsResponse({this.status, this.shipments, this.message});

  factory UserShipmentsResponse.fromMap(Map<String, dynamic> data) =>
      UserShipmentsResponse(
        status: data['status'] as bool?,
        message: data['message'] as String?,
        shipments: (data['shipments'] as List<dynamic>?)
            ?.map((e) => Shipment.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'shipments': shipments?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserShipmentsResponse].
  factory UserShipmentsResponse.fromJson(String data) {
    print('fromm');
    return UserShipmentsResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserShipmentsResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  GetUserShipmentsDto toUserShipmentsDto() {
    print('userrrrrrr');
    return GetUserShipmentsDto(
        message: message,
        shipments:
            shipments?.map((shipment) => shipment.toShipmentDto()).toList(),
        status: status);
  }
}
