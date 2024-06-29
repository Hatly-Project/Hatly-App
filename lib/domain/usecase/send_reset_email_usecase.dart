import 'package:hatly/domain/models/send_reset_email_response_dto.dart';
import 'package:hatly/domain/repository/auth_repository.dart';

class SendResetEmailUsecase {
  AuthRepository authRepository;

  SendResetEmailUsecase(this.authRepository);

  Future<SendResetEmailResponseDto> invoke(String email) {
    return authRepository.sendResetEmail(email);
  }
}
