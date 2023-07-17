import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hatly/domain/customException/custom_exception.dart';

class FirebaseManager {
  Future<void> registerUser(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('msg ${e.message}');
        throw ServerErrorException('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('msg ${e.message}');

        throw ServerErrorException(
            'The account already exists for that email.');
      }
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ServerErrorException('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw ServerErrorException('Wrong password provided for that user.');
      }
    }
  }
}
