import 'dart:convert';

import 'package:hatly/domain/models/send_reset_email_response_dto.dart';

class SendResetEmailResponse {
  String? message;
  bool? status;

  SendResetEmailResponse({this.message, this.status});

  factory SendResetEmailResponse.fromMap(Map<String, dynamic> data) {
    return SendResetEmailResponse(
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
  /// Parses the string and returns the resulting Json object as [SendResetEmailResponse].
  factory SendResetEmailResponse.fromJson(String data) {
    return SendResetEmailResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SendResetEmailResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  SendResetEmailResponseDto toDto() {
    return SendResetEmailResponseDto(message: message, status: status);
  }
}
