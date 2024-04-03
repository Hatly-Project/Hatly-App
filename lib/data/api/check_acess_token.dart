import 'dart:convert';

class CheckAcessTokenRequest {
  String? token;

  CheckAcessTokenRequest({this.token});

  factory CheckAcessTokenRequest.fromMap(Map<String, dynamic> data) {
    return CheckAcessTokenRequest(
      token: data['token'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'token': token,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CheckAcessTokenRequest].
  factory CheckAcessTokenRequest.fromJson(String data) {
    return CheckAcessTokenRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CheckAcessTokenRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
