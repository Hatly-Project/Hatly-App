import 'package:hatly/domain/repository/auth_repository.dart';

class LoginUseCase {
  AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<void> invoke(String email, String password) async {
    await authRepository.login(email, password);
  }
}
