import 'dart:convert';

class UserDto {
  String? name;
  String? email;
  dynamic phone;
  String? profilePhoto;
  int? id;
  List<dynamic>? review;

  UserDto(
      {required this.name,
      required this.phone,
      required this.email,
      required this.profilePhoto,
      this.id,
      this.review});

  factory UserDto.fromMap(Map<String, dynamic> data) => UserDto(
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
  factory UserDto.fromJson(String data) {
    return UserDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());
}
