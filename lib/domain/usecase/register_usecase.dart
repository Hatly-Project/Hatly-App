import 'package:hatly/domain/repository/auth_repository.dart';

class RegisterUseCase {
  AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  Future<void> invoke(String email, String password) async {
    await authRepository.register(email, password);
  }
}
