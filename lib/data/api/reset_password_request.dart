import 'dart:convert';

class ResetPasswordRequest {
  String? otp;
  String? newPassword;

  ResetPasswordRequest({this.otp, this.newPassword});

  factory ResetPasswordRequest.fromMap(Map<String, dynamic> data) {
    return ResetPasswordRequest(
      otp: data['otp'] as String?,
      newPassword: data['newPassword'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'otp': otp,
        'newPassword': newPassword,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ResetPasswordRequest].
  factory ResetPasswordRequest.fromJson(String data) {
    return ResetPasswordRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ResetPasswordRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
