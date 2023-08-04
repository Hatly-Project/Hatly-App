import 'package:hatly/domain/models/login_response_dto.dart';
import 'package:hatly/domain/repository/auth_repository.dart';

class LoginUseCase {
  AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<LoginResponseDto> invoke(String email, String password) async {
    return authRepository.login(email, password);
  }
}
