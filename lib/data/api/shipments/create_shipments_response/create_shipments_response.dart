import 'dart:convert';

import 'package:hatly/data/api/shipments/shipment.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';

class CreateShipmentsResponse {
  bool? status;
  String? message;
  Shipment? shipment;

  CreateShipmentsResponse({this.status, this.shipment, this.message});

  factory CreateShipmentsResponse.fromMap(Map<String, dynamic> data) {
    return CreateShipmentsResponse(
      status: data['status'] as bool?,
      message: data['message'] as String?,
      shipment: data['shipment'] == null
          ? null
          : Shipment.fromMap(data['shipment'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'shipment': shipment?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CreateShipmentsResponse].
  factory CreateShipmentsResponse.fromJson(String data) {
    return CreateShipmentsResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CreateShipmentsResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  CreateShipmentsResponseDto toShipmentResponseDto() {
    return CreateShipmentsResponseDto(
        status: status, shipment: shipment?.toShipmentDto(), message: message);
  }
}
