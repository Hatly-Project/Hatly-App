import 'package:hatly/data/api/update_payment_info_response.dart';
import 'package:hatly/domain/models/update_payment_info_response_dto.dart';

abstract class ProfileRepository {
  Future<UpdatePaymentInfoResponseDto> updatePaymentInfo(
      {String? accountNumber,
      String? routingNumber,
      String? accountName,
      int? userId,
      String? accountCurrency,
      String? accountCountry});

  Future<UpdatePaymentInfoResponseDto> updateProfile(
      {String? dob,
      String? address,
      String? city,
      String? country,
      String? postalCode,
      String? ip,
      required String? accessToken,
      String? phone});
}
