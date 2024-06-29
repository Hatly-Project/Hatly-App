import 'package:hatly/domain/models/login_response_dto.dart';
import 'package:hatly/domain/models/send_reset_email_response_dto.dart';

import '../models/register_response_dto.dart';

abstract class AuthRepository {
  Future<RegisterResponseDto> register(
      {String? email,
      String? password,
      String? firstName,
      String? lastName,
      String? dob,
      String? address,
      String? city,
      String? country,
      String? phone,
      String? postalCode,
      String? ip,
      required String? fcmToken});
  Future<LoginResponseDto> login(String email, String password);

  Future<LoginResponseDto> loginWithGoogle(String idToken);

  Future<SendResetEmailResponseDto> sendResetEmail(String email);

  Future<SendResetEmailResponseDto> verifyOtp(String otp);
}
