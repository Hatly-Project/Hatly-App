import 'dart:convert';

class User {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? address;
  String? city;
  String? country;
  String? postalCode;
  String? phone;
  dynamic profilePhoto;
  DateTime? dataOfBirth;
  dynamic passportPhoto;
  String? fcmToken;
  int? averageRating;
  DateTime? createdAt;
  bool? verify;

  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.phone,
    this.profilePhoto,
    this.dataOfBirth,
    this.passportPhoto,
    this.fcmToken,
    this.averageRating,
    this.createdAt,
    this.verify,
  });

  factory User.fromMap(Map<String, dynamic> data) => User(
        id: data['id'] as int?,
        email: data['email'] as String?,
        firstName: data['firstName'] as String?,
        lastName: data['lastName'] as String?,
        address: data['address'] as String?,
        city: data['city'] as String?,
        country: data['country'] as String?,
        postalCode: data['postalCode'] as String?,
        phone: data['phone'] as String?,
        profilePhoto: data['profilePhoto'] as dynamic,
        dataOfBirth: data['dataOfBirth'] == null
            ? null
            : DateTime.parse(data['dataOfBirth'] as String),
        passportPhoto: data['passportPhoto'] as dynamic,
        fcmToken: data['fcmToken'] as String?,
        averageRating: data['averageRating'] as int?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        verify: data['verify'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'city': city,
        'country': country,
        'postalCode': postalCode,
        'phone': phone,
        'profilePhoto': profilePhoto,
        'dataOfBirth': dataOfBirth?.toIso8601String(),
        'passportPhoto': passportPhoto,
        'fcmToken': fcmToken,
        'averageRating': averageRating,
        'createdAt': createdAt?.toIso8601String(),
        'verify': verify,
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
}
