import 'dart:convert';

import 'package:hatly/domain/models/deal_response_dto.dart';

class DealResponse {
  bool? status;
  String? message;

  DealResponse({this.status, this.message});

  factory DealResponse.fromMap(Map<String, dynamic> data) {
    return DealResponse(
      status: data['status'] as bool?,
      message: data['message'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DealResponse].
  factory DealResponse.fromJson(String data) {
    return DealResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DealResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  DealResponseDto toDto() {
    return DealResponseDto(status: status, message: message);
  }
}
