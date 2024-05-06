import 'dart:convert';

import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/domain/models/trip_matching_shipments_response_dto.dart';

class TripMatchingShipmentsResponse {
  bool? status;
  String? message;
  List<Shipment>? shipments;

  TripMatchingShipmentsResponse({this.status, this.shipments, this.message});

  factory TripMatchingShipmentsResponse.fromMap(Map<String, dynamic> data) {
    return TripMatchingShipmentsResponse(
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
  /// Parses the string and returns the resulting Json object as [TripMatchingShipmentsResponse].
  factory TripMatchingShipmentsResponse.fromJson(String data) {
    return TripMatchingShipmentsResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TripMatchingShipmentsResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  TripMatchingShipmentsResponseDto toDto() {
    return TripMatchingShipmentsResponseDto(
      status: status,
      message: message,
      shipments:
          shipments?.map((shipment) => shipment.toShipmentDto()).toList(),
    );
  }
}
