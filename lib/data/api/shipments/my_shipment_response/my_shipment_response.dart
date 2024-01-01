import 'dart:convert';

import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';

class MyShipmentResponse {
  bool? status;
  List<Shipment>? shipments;
  String? message;

  MyShipmentResponse({this.status, this.shipments, this.message});

  factory MyShipmentResponse.fromMap(Map<String, dynamic> data) {
    return MyShipmentResponse(
      status: data['status'] as bool?,
      message: data['message'] as String?,
      shipments: (data['shipments'] as List<dynamic>?)
          ?.map((e) => Shipment.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'shipments': shipments?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MyShipmentResponse].
  factory MyShipmentResponse.fromJson(String data) {
    return MyShipmentResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MyShipmentResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  GetUserShipmentsDto toUserShipmentDto() {
    return GetUserShipmentsDto(
        shipments:
            shipments?.map((shipment) => shipment.toShipmentDto()).toList(),
        status: status,
        message: message);
  }
}
