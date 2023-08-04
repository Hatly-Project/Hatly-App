import 'package:cloud_firestore/cloud_firestore.dart';

class UserDto {
  String? email;
  String? name;
  dynamic phone;
  String? imageUrl;

  UserDto({
    required this.name,
    required this.phone,
    required this.email,
    required this.imageUrl,
  });
}
