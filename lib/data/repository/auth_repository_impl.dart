import 'package:hatly/domain/repository/auth_repository.dart';

import '../../domain/datasource/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthDataSource authDataSource;

  AuthRepositoryImpl(this.authDataSource);

  @override
  Future<void> register(String email, String password) async {
    await authDataSource.register(email, password);
  }

  @override
  Future<void> login(String email, String password) async {
    await authDataSource.login(email, password);
  }
}
