import 'dart:convert';

import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/domain/models/get_all_shipments_dto.dart';

class GetShipmentsResponse {
  bool? status;
  String? message;

  List<Shipment>? shipments;

  GetShipmentsResponse({this.status, this.shipments, this.message});

  factory GetShipmentsResponse.fromMap(Map<String, dynamic> data) {
    return GetShipmentsResponse(
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
  /// Parses the string and returns the resulting Json object as [GetShipmentsResponse].
  factory GetShipmentsResponse.fromJson(String data) {
    return GetShipmentsResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GetShipmentsResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  GetAllShipmentResponseDto toGetAllShipmetnsDto() {
    return GetAllShipmentResponseDto(
        shipments:
            shipments?.map((shipment) => shipment.toShipmentDto()).toList(),
        status: status,
        message: message);
  }
}
