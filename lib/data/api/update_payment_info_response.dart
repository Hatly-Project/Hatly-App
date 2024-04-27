import 'dart:convert';

import 'package:hatly/domain/models/update_payment_info_response_dto.dart';

class UpdatePaymentInfoResponse {
  String? message;
  bool? status;

  UpdatePaymentInfoResponse({this.message, this.status});

  factory UpdatePaymentInfoResponse.fromMap(Map<String, dynamic> data) {
    return UpdatePaymentInfoResponse(
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
  /// Parses the string and returns the resulting Json object as [UpdatePaymentInfoResponse].
  factory UpdatePaymentInfoResponse.fromJson(String data) {
    return UpdatePaymentInfoResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UpdatePaymentInfoResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  UpdatePaymentInfoResponseDto toDto() {
    return UpdatePaymentInfoResponseDto(message: message, status: status);
  }
}
