import 'dart:convert';

import 'package:hatly/domain/models/shopper_dto.dart';

class Shopper {
  int? id;
  String? email;
  String? firstName;
  String? phone;
  dynamic profilePhoto;
  int? averageRating;
  bool? verify;

  Shopper({
    this.id,
    this.email,
    this.firstName,
    this.phone,
    this.profilePhoto,
    this.averageRating,
    this.verify,
  });

  factory Shopper.fromMap(Map<String, dynamic> data) => Shopper(
        id: data['id'] as int?,
        email: data['email'] as String?,
        firstName: data['firstName'] as String?,
        phone: data['phone'] as String?,
        profilePhoto: data['profilePhoto'] as dynamic,
        averageRating: data['averageRating'] as int?,
        verify: data['verify'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'phone': phone,
        'profilePhoto': profilePhoto,
        'averageRating': averageRating,
        'verify': verify,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Shopper].
  factory Shopper.fromJson(String data) {
    return Shopper.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Shopper] to a JSON string.
  String toJson() => json.encode(toMap());

  ShopperDto toDto() {
    return ShopperDto(
      id: id,
      email: email,
      firstName: firstName,
      phone: phone,
      profilePhoto: profilePhoto,
      averageRating: averageRating,
      verify: verify,
    );
  }
}
