import 'dart:convert';

class RegisterRequest {
  String? email;
  String? password;
  String? name;
  String? phone;
  String? image;

  RegisterRequest(
      {this.email, this.password, this.name, this.image, this.phone});

  factory RegisterRequest.fromMap(Map<String, dynamic> data) {
    return RegisterRequest(
      email: data['email'] as String?,
      password: data['password'] as String?,
      name: data['name'] as String?,
      phone: data['phone'] as String?,
      image: data['image'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'image': image,
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
