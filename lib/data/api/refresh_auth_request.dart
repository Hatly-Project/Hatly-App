import 'dart:convert';

class RefreshAuthRequest {
  String? token;

  RefreshAuthRequest({this.token});

  factory RefreshAuthRequest.fromMap(Map<String, dynamic> data) {
    return RefreshAuthRequest(
      token: data['token'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'token': token,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RefreshAuthRequest].
  factory RefreshAuthRequest.fromJson(String data) {
    return RefreshAuthRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RefreshAuthRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
