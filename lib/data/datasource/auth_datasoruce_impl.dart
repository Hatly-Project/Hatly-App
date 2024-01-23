import 'package:hatly/domain/datasource/auth_datasource.dart';
import 'package:hatly/domain/models/login_response_dto.dart';
import 'package:hatly/domain/models/register_response_dto.dart';

import '../api/api_manager.dart';

class AuthDataSourceImpl implements AuthDataSource {
  ApiManager apiManager;

  AuthDataSourceImpl(this.apiManager);

  @override
  Future<RegisterResponseDto> register(
      {String? name,
      String? email,
      String? phone,
      String? image,
      String? password,
      String? fcmToken}) async {
    var response = await apiManager.registerUser(
      name: name,
      email: email,
      phone: phone,
      image: image,
      password: password,
      fcmToken: fcmToken,
    );

    return response.toRegisterDto();
  }

  @override
  Future<LoginResponseDto> login(String email, String password) async {
    var response = await apiManager.loginUser(email, password);

    return response.toLoginDto();
  }
}
