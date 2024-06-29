import 'package:hatly/domain/models/send_reset_email_response_dto.dart';
import 'package:hatly/domain/repository/auth_repository.dart';

class ResetPasswordUsecase {
  AuthRepository authRepository;

  ResetPasswordUsecase(this.authRepository);

  Future<SendResetEmailResponseDto> invoke({String? otp, String? newPassword}) {
    return authRepository.resetPassword(otp!, newPassword!);
  }
}
