import 'package:hatly/data/api/send_reset_email_response.dart';
import 'package:hatly/domain/models/send_reset_email_response_dto.dart';
import 'package:hatly/domain/repository/auth_repository.dart';

class VerifyOtpUsecase {
  AuthRepository authRepository;

  VerifyOtpUsecase(this.authRepository);

  Future<SendResetEmailResponseDto> invoke(String otp) {
    return authRepository.verifyOtp(otp);
  }
}
