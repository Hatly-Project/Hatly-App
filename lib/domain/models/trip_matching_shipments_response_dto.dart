import 'dart:convert';

import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/domain/models/shipment_dto.dart';

class TripMatchingShipmentsResponseDto {
  bool? status;
  String? message;
  List<ShipmentDto>? shipments;

  TripMatchingShipmentsResponseDto({this.status, this.shipments, this.message});

  factory TripMatchingShipmentsResponseDto.fromMap(Map<String, dynamic> data) {
    return TripMatchingShipmentsResponseDto(
      status: data['status'] as bool?,
      message: data['message'] as String?,
      shipments: (data['shipments'] as List<dynamic>?)
          ?.map((e) => ShipmentDto.fromMap(e as Map<String, dynamic>))
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
  /// Parses the string and returns the resulting Json object as [TripMatchingShipmentsResponseDto].
  factory TripMatchingShipmentsResponseDto.fromJson(String data) {
    return TripMatchingShipmentsResponseDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TripMatchingShipmentsResponseDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
