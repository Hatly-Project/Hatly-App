import 'dart:convert';

class RegisterRequest {
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? dob;
  String? address;
  String? city;
  String? country;
  String? phone;
  String? postalCode;
  String? ip;
  String? fcmToken;

  RegisterRequest({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.dob,
    this.address,
    this.city,
    this.country,
    this.phone,
    this.postalCode,
    this.ip,
    this.fcmToken,
  });

  factory RegisterRequest.fromMap(Map<String, dynamic> data) {
    return RegisterRequest(
      email: data['email'] as String?,
      password: data['password'] as String?,
      firstName: data['firstName'] as String?,
      lastName: data['lastName'] as String?,
      dob: data['dob'] as String?,
      address: data['address'] as String?,
      city: data['city'] as String?,
      country: data['country'] as String?,
      phone: data['phone'] as String?,
      postalCode: data['postalCode'] as String?,
      ip: data['ip'] as String?,
      fcmToken: data['fcmToken'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'dob': dob,
        'address': address,
        'city': city,
        'country': country,
        'phone': phone,
        'postalCode': postalCode,
        'ip': ip,
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
