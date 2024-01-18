import 'dart:convert';

import 'package:hatly/data/api/shipment.dart';
import 'package:hatly/domain/models/shipment_dto.dart';

class TripDealRequestDto {
  List<ShipmentDto>? shipments;
  double? reward;

  TripDealRequestDto({this.shipments, this.reward});

  factory TripDealRequestDto.fromMap(Map<String, dynamic> data) {
    return TripDealRequestDto(
      shipments: (data['shipments'] as List<dynamic>?)
          ?.map((e) => ShipmentDto.fromMap(e as Map<String, dynamic>))
          .toList(),
      reward: (data['reward'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'shipments': shipments?.map((e) => e.toMap()).toList(),
        'reward': reward,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TripDealRequestDto].
  factory TripDealRequestDto.fromJson(String data) {
    return TripDealRequestDto.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TripDealRequestDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
