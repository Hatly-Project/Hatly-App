import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? fullName;
  String? mobileNo;
  String? email;
  String? password;
  String? rePassword;

  User(
      {required this.fullName,
      required this.mobileNo,
      required this.email,
      required this.password,
      required this.rePassword});

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      fullName: data?['full name'],
      mobileNo: data?['mobile'],
      email: data?['email'],
      password: data?['password'],
      rePassword: data?['rePassword'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (fullName != null) "full name": fullName,
      if (mobileNo != null) "mobileNo": mobileNo,
      if (email != null) "email": email,
      if (password != null) "password": password,
      if (rePassword != null) "rePassword": rePassword,
    };
  }
}
