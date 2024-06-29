import 'dart:convert';

class VerifyOtpRequest {
  String? otp;

  VerifyOtpRequest({this.otp});

  factory VerifyOtpRequest.fromMap(Map<String, dynamic> data) {
    return VerifyOtpRequest(
      otp: data['otp'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'otp': otp,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [VerifyOtpRequest].
  factory VerifyOtpRequest.fromJson(String data) {
    return VerifyOtpRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [VerifyOtpRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
