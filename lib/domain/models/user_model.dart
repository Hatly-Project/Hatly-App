import 'dart:convert';

import 'package:hatly/data/api/user.dart';

class UserDto {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? profilePhoto;
  int? id;
  double? averageRating;

  UserDto({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.profilePhoto,
    this.id,
    this.averageRating,
  });

  factory UserDto.fromMap(Map<String, dynamic> data) => UserDto(
      firstName: data['firstName'] as String?,
      lastName: data['lastName'] as String?,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      profilePhoto: data['ProfilePhoto'] as String?,
      id: data['id'] as int?,
      averageRating: (data['averageRating'] as num?)?.toDouble());

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'ProfilePhoto': profilePhoto,
        'id': id,
        'averageRating': averageRating,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory UserDto.fromJson(String data) {
    return UserDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());

  User toUser() {
    return User(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        profilePhoto: profilePhoto,
        id: id,
        averageRating: averageRating);
  }
}
