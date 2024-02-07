import 'dart:convert';

class RefreshTokenResponse {
  String? message;
  bool? status;

  RefreshTokenResponse({this.message, this.status});

  factory RefreshTokenResponse.fromMap(Map<String, dynamic> data) {
    return RefreshTokenResponse(
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
  /// Parses the string and returns the resulting Json object as [RefreshTokenResponse].
  factory RefreshTokenResponse.fromJson(String data) {
    return RefreshTokenResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RefreshTokenResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
