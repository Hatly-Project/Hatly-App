import 'package:hatly/domain/models/login_response_dto.dart';

import '../models/register_response_dto.dart';

abstract class AuthDataSource {
  Future<RegisterResponseDto> register(
      {String? name,
      String? email,
      String? phone,
      String? image,
      String? password,
      String? fcmToken});
  Future<LoginResponseDto> login(String email, String password);
}
