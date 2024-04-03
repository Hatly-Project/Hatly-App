import 'dart:convert';

class RefreshAccessTokenResponse {
  String? accessToken;
  bool? status;
  String? message;

  RefreshAccessTokenResponse({this.accessToken, this.status, this.message});

  factory RefreshAccessTokenResponse.fromMap(Map<String, dynamic> data) {
    return RefreshAccessTokenResponse(
      message: data['message'] as String?,
      accessToken: data['accessToken'] as String?,
      status: data['status'] as bool?,
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'accessToken': accessToken,
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RefreshAccessTokenResponse].
  factory RefreshAccessTokenResponse.fromJson(String data) {
    return RefreshAccessTokenResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RefreshAccessTokenResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
