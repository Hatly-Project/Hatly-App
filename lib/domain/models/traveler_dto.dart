import 'dart:convert';

import 'package:hatly/data/api/traveler.dart';

class TravelerDto {
  int? id;
  String? email;
  String? firstName, lastName;
  String? phone;
  dynamic profilePhoto;
  double? averageRating;
  bool? verify;

  TravelerDto({
    this.id,
    this.firstName,
    this.lastName,
    this.averageRating = 0,
    this.email,
    this.phone,
    this.profilePhoto,
    this.verify,
  });

  factory TravelerDto.fromMap(Map<String, dynamic> data) => TravelerDto(
        id: data['id'] as int?,
        email: data['email'] as String?,
        firstName: data['firstName'] as String?,
        lastName: data['lastName'] as String?,
        averageRating: (data['averageRating'] as num?)?.toDouble(),
        phone: data['phone'] as String?,
        profilePhoto: data['profilePhoto'] as dynamic,
        verify: data['verify'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'averageRating': averageRating,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'profilePhoto': profilePhoto,
        'verify': verify,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TravelerDto].
  factory TravelerDto.fromJson(String data) {
    return TravelerDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TravelerDto] to a JSON string.
  String toJson() => json.encode(toMap());

  Traveler toTraveler() {
    return Traveler(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        profilePhoto: profilePhoto,
        averageRating: averageRating,
        verify: verify);
  }
}
