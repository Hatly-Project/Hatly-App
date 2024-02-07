import 'dart:convert';

class RefreshTokenRequest {
  String? fcmToken;

  RefreshTokenRequest({this.fcmToken});

  factory RefreshTokenRequest.fromMap(Map<String, dynamic> data) {
    return RefreshTokenRequest(
      fcmToken: data['fcmToken'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'fcmToken': fcmToken,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RefreshTokenRequest].
  factory RefreshTokenRequest.fromJson(String data) {
    return RefreshTokenRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RefreshTokenRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
