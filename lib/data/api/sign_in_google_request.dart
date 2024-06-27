import 'dart:convert';

class SignInGoogleRequest {
  String? idToken;

  SignInGoogleRequest({this.idToken});

  factory SignInGoogleRequest.fromMap(Map<String, dynamic> data) {
    return SignInGoogleRequest(
      idToken: data['idToken'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'idToken': idToken,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SignInGoogleRequest].
  factory SignInGoogleRequest.fromJson(String data) {
    return SignInGoogleRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SignInGoogleRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
