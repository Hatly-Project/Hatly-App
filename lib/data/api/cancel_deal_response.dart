import 'dart:convert';

import 'package:hatly/domain/models/cancel_deal_response_dto.dart';

class CancelDealResponse {
  String? message;
  bool? status;

  CancelDealResponse({this.message, this.status});

  factory CancelDealResponse.fromMap(Map<String, dynamic> data) {
    return CancelDealResponse(
      message: data['message'] as String?,
      status: data['status'] as bool?,
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CancelDealResponse].
  factory CancelDealResponse.fromJson(String data) {
    return CancelDealResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CancelDealResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  CancelDealResponseDto toResponseDto() {
    return CancelDealResponseDto(status: status, message: message);
  }
}
