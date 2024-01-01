import 'dart:convert';

import 'package:hatly/domain/models/user_model.dart';

class User {
  String? name;
  String? email;
  dynamic phone;
  String? profilePhoto;
  int? id;
  List<dynamic>? review;

  User({
    this.name,
    this.email,
    this.phone,
    this.profilePhoto,
    this.id,
    this.review,
  });

  factory User.fromMap(Map<String, dynamic> data) => User(
        name: data['name'] as String?,
        email: data['email'] as String?,
        phone: data['phone'] as dynamic,
        profilePhoto: data['ProfilePhoto'] as String?,
        id: data['id'] as int?,
        review: data['review'] as List<dynamic>?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'phone': phone,
        'ProfilePhoto': profilePhoto,
        'id': id,
        'review': review,
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
    return UserDto(
        name: name, phone: phone, email: email, profilePhoto: profilePhoto);
  }
}
