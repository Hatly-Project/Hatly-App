import 'package:hatly/domain/models/login_response_dto.dart';
import 'package:hatly/domain/repository/auth_repository.dart';

class LoginWithGoogleUseCase {
  AuthRepository authRepository;

  LoginWithGoogleUseCase(this.authRepository);

  Future<LoginResponseDto> invoke(String idToken) async {
    return authRepository.loginWithGoogle(idToken);
  }
}
