import 'package:hatly/domain/datasource/auth_datasource.dart';

import '../firebase/firebase_manager.dart';

class AuthDataSourceImpl implements AuthDataSource {
  FirebaseManager firebaseManager;

  AuthDataSourceImpl(this.firebaseManager);

  @override
  Future<void> register(String email, String password) async {
    await firebaseManager.registerUser(email, password);
  }

  @override
  Future<void> login(String email, String password) async {
    await firebaseManager.loginUser(email, password);
  }
}
