import 'dart:convert';

import 'package:hatly/domain/models/user_model.dart';

class User {
  String? email;
  String? name;
  String? phone;
  String? imageUrl;

  User({this.email, this.name, this.phone, this.imageUrl});

  factory User.fromMap(Map<String, dynamic> data) => User(
        email: data['email'] as String?,
        name: data['name'] as String?,
        phone: data['phone'] as String?,
        imageUrl: data['imageUrl'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'email': email,
        'name': name,
        'phone': phone,
        'imageUrl': imageUrl,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());

  UserDto toUserDto() {
    return UserDto(name: name, phone: phone, email: email, imageUrl: imageUrl);
  }
}
