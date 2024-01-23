import 'package:hatly/domain/models/register_response_dto.dart';
import 'package:hatly/domain/repository/auth_repository.dart';

class RegisterUseCase {
  AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  Future<RegisterResponseDto> invoke(
      {String? name,
      String? email,
      String? phone,
      String? image,
      String? password,
      required String? fcmToken}) async {
    return authRepository.register(
        name: name,
        email: email,
        phone: phone,
        image: image,
        password: password,
        fcmToken: fcmToken);
  }
}
