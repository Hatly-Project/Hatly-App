import 'package:hatly/domain/models/login_response_dto.dart';
import 'package:hatly/domain/models/send_reset_email_response_dto.dart';
import 'package:hatly/domain/repository/auth_repository.dart';

import '../../domain/datasource/auth_datasource.dart';
import '../../domain/models/register_response_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthDataSource authDataSource;

  AuthRepositoryImpl(this.authDataSource);

  @override
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
      required String? fcmToken}) async {
    return authDataSource.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      ip: ip,
      phone: phone,
      password: password,
      fcmToken: fcmToken,
    );
  }

  @override
  Future<LoginResponseDto> login(String email, String password) async {
    return authDataSource.login(email, password);
  }

  @override
  Future<LoginResponseDto> loginWithGoogle(String idToken) {
    return authDataSource.loginWithGoogle(idToken);
  }

  @override
  Future<SendResetEmailResponseDto> sendResetEmail(String email) {
    return authDataSource.sendResetEmail(email);
  }

  @override
  Future<SendResetEmailResponseDto> verifyOtp(String otp) {
    return authDataSource.verifyOtp(otp);
  }

  @override
  Future<SendResetEmailResponseDto> resetPassword(
      String otp, String newPassword) {
    return authDataSource.resetPassword(otp, newPassword);
  }
}
