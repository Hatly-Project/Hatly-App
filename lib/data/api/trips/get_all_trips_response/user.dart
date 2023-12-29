import 'dart:convert';

class User {
  int? id;
  String? name;
  String? email;
  dynamic phone;
  dynamic profilePhoto;
  List<dynamic>? reviewed;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profilePhoto,
    this.reviewed,
  });

  factory User.fromMap(Map<String, dynamic> data) => User(
        id: data['id'] as int?,
        name: data['name'] as String?,
        email: data['email'] as String?,
        phone: data['phone'] as dynamic,
        profilePhoto: data['profilePhoto'] as dynamic,
        reviewed: data['reviewed'] as List<dynamic>?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'profilePhoto': profilePhoto,
        'reviewed': reviewed,
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
