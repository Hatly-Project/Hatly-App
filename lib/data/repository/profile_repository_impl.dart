import 'package:hatly/data/api/update_payment_info_response.dart';
import 'package:hatly/domain/datasource/profile_datasource.dart';
import 'package:hatly/domain/models/update_payment_info_response_dto.dart';
import 'package:hatly/domain/repository/profile_repository.dart';

class PaymentInfoRepositoryImpl implements ProfileRepository {
  ProfileDatasource profileDatasource;

  PaymentInfoRepositoryImpl(this.profileDatasource);
  @override
  Future<UpdatePaymentInfoResponseDto> updatePaymentInfo(
      {String? accountNumber,
      String? routingNumber,
      String? accountName,
      int? userId,
      String? accountCurrency,
      String? accountCountry}) {
    return profileDatasource.updatePaymentInfo(
        accountNumber: accountNumber,
        accountName: accountName,
        accountCountry: accountCountry,
        routingNumber: routingNumber,
        userId: userId,
        accountCurrency: accountCurrency);
  }

  @override
  Future<UpdatePaymentInfoResponseDto> updateProfile(
      {String? dob,
      String? address,
      String? city,
      String? country,
      String? postalCode,
      String? ip,
      required String? accessToken,
      String? phone}) {
    return profileDatasource.updateProfile(
      accessToken: accessToken,
      dob: dob,
      address: address,
      city: city,
      country: country,
      phone: phone,
      postalCode: postalCode,
      ip: ip,
    );
  }
}
