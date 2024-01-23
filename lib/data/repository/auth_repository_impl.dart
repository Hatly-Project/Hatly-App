import 'package:hatly/domain/models/login_response_dto.dart';
import 'package:hatly/domain/repository/auth_repository.dart';

import '../../domain/datasource/auth_datasource.dart';
import '../../domain/models/register_response_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthDataSource authDataSource;

  AuthRepositoryImpl(this.authDataSource);

  @override
  Future<RegisterResponseDto> register(
      {String? name,
      String? email,
      String? phone,
      String? image,
      String? password,
      String? fcmToken}) async {
    return authDataSource.register(
      name: name,
      email: email,
      phone: phone,
      image: image,
      password: password,
      fcmToken: fcmToken,
    );
  }

  @override
  Future<LoginResponseDto> login(String email, String password) async {
    return authDataSource.login(email, password);
  }
}
