import 'package:hatly/domain/models/register_response_dto.dart';
import 'package:hatly/domain/repository/auth_repository.dart';

class RegisterUseCase {
  AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  Future<RegisterResponseDto> invoke(
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
      required String? ip,
      required String? fcmToken}) async {
    return authRepository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        ip: ip,
        phone: phone,
        password: password,
        fcmToken: fcmToken);
  }
}
