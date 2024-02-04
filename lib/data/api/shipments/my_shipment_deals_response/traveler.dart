import 'dart:convert';

import 'package:hatly/domain/models/traveler_dto.dart';

class Traveler {
  int? id;
  String? email;
  String? phone;
  dynamic profilePhoto;
  bool? verify;

  Traveler({
    this.id,
    this.email,
    this.phone,
    this.profilePhoto,
    this.verify,
  });

  factory Traveler.fromMap(Map<String, dynamic> data) => Traveler(
        id: data['id'] as int?,
        email: data['email'] as String?,
        phone: data['phone'] as String?,
        profilePhoto: data['profilePhoto'] as dynamic,
        verify: data['verify'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'phone': phone,
        'profilePhoto': profilePhoto,
        'verify': verify,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Traveler].
  factory Traveler.fromJson(String data) {
    return Traveler.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Traveler] to a JSON string.
  String toJson() => json.encode(toMap());

  TravelerDto toTravelerDto() {
    return TravelerDto(
        id: id,
        email: email,
        phone: phone,
        profilePhoto: profilePhoto,
        verify: verify);
  }
}
