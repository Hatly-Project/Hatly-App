import 'dart:convert';

class ShopperDto {
  int? id;
  String? email;
  String? firstName;
  String? phone;
  dynamic profilePhoto;
  int? averageRating;
  bool? verify;

  ShopperDto({
    this.id,
    this.email,
    this.firstName,
    this.phone,
    this.profilePhoto,
    this.averageRating,
    this.verify,
  });

  factory ShopperDto.fromMap(Map<String, dynamic> data) => ShopperDto(
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
  /// Parses the string and returns the resulting Json object as [ShopperDto].
  factory ShopperDto.fromJson(String data) {
    return ShopperDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ShopperDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
