import 'package:hatly/domain/models/update_payment_info_response_dto.dart';
import 'package:hatly/domain/repository/profile_repository.dart';

class UpdateProfileUsecase {
  ProfileRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<UpdatePaymentInfoResponseDto> updateProfile(
      {String? dob,
      String? address,
      String? city,
      String? country,
      String? postalCode,
      String? ip,
      required String? accessToken,
      String? phone}) {
    return repository.updateProfile(
        accessToken: accessToken,
        dob: dob,
        address: address,
        city: city,
        country: country,
        postalCode: postalCode,
        ip: ip,
        phone: phone);
  }
}
