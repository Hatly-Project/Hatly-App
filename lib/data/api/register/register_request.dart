import 'dart:convert';

class RegisterRequest {
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? fcmToken;

  RegisterRequest({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.fcmToken,
  });

  factory RegisterRequest.fromMap(Map<String, dynamic> data) {
    return RegisterRequest(
      email: data['email'] as String?,
      password: data['password'] as String?,
      firstName: data['firstName'] as String?,
      lastName: data['lastName'] as String?,
      fcmToken: data['fcmToken'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'fcmToken': fcmToken,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RegisterRequest].
  factory RegisterRequest.fromJson(String data) {
    return RegisterRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RegisterRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
