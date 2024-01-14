import 'dart:convert';

import 'package:hatly/domain/models/user_model.dart';

class User {
  String? name;
  String? email;
  String? phone;
  String? profilePhoto;
  int? id;
  double? averageRating;

  User({
    this.name,
    this.email,
    this.phone,
    this.profilePhoto,
    this.id,
    this.averageRating = 0,
  });

  factory User.fromMap(Map<String, dynamic> data) => User(
        name: data['name'] as String?,
        email: data['email'] as String?,
        phone: data['phone'] as String?,
        profilePhoto: data['ProfilePhoto'] as String?,
        id: data['id'] as int?,
        averageRating: (data['averageRating'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'phone': phone,
        'ProfilePhoto': profilePhoto,
        'id': id,
        'averageRating': averageRating,
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
        name: name,
        phone: phone,
        email: email,
        profilePhoto: profilePhoto,
        averageRating: averageRating);
  }
}
