import 'dart:convert';

import 'package:hatly/domain/models/my_shipment_deals_response_dto.dart';

import 'deal.dart';

class MyShipmentDealsResponse {
  bool? status;
  String? message;
  List<Deal>? deals;

  MyShipmentDealsResponse({this.status, this.deals, this.message});

  factory MyShipmentDealsResponse.fromMap(Map<String, dynamic> data) {
    return MyShipmentDealsResponse(
      status: data['status'] as bool?,
      message: data['message'] as String?,
      deals: (data['deals'] as List<dynamic>?)
          ?.map((e) => Deal.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'deals': deals?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MyShipmentDealsResponse].
  factory MyShipmentDealsResponse.fromJson(String data) {
    return MyShipmentDealsResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MyShipmentDealsResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  MyShipmentDealsResponseDto toMyShipmentDealsResponseDto() {
    return MyShipmentDealsResponseDto(
      status: status,
      message: message,
      deals: deals?.map((deal) => deal.toDealDto()).toList(),
    );
  }
}
