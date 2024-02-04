import 'dart:convert';

import 'package:hatly/data/api/shipments/my_shipment_deals_response/traveler.dart';

class TravelerDto {
  int? id;
  String? email;
  String? phone;
  dynamic profilePhoto;
  bool? verify;

  TravelerDto({
    this.id,
    this.email,
    this.phone,
    this.profilePhoto,
    this.verify,
  });

  factory TravelerDto.fromMap(Map<String, dynamic> data) => TravelerDto(
        id: data['id'] as int?,
        email: data['email'] as String?,
        phone: data['phone'] as String,
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
        phone: phone,
        profilePhoto: profilePhoto,
        verify: verify);
  }
}
