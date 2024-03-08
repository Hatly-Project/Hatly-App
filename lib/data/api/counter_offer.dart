import 'dart:convert';

import 'package:hatly/domain/models/counter_offer_response_dto.dart';

class CounterOfferResponse {
  String? message;
  bool? status;

  CounterOfferResponse({this.message, this.status});

  factory CounterOfferResponse.fromMap(Map<String, dynamic> data) =>
      CounterOfferResponse(
        message: data['message'] as String?,
        status: data['status'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CounterOfferResponse].
  factory CounterOfferResponse.fromJson(String data) {
    return CounterOfferResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CounterOfferResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  CounterOfferResponseDto toResponseDto() {
    return CounterOfferResponseDto(message: message, status: status);
  }
}
