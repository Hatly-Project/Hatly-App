import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/data/api/update_payment_info_response.dart';
import 'package:hatly/domain/datasource/profile_datasource.dart';
import 'package:hatly/domain/models/update_payment_info_response_dto.dart';

class PaymentInfoDatasourceImpl implements ProfileDatasource {
  ApiManager apiManager;

  PaymentInfoDatasourceImpl(this.apiManager);
  @override
  Future<UpdatePaymentInfoResponseDto> updatePaymentInfo(
      {String? accountNumber,
      String? routingNumber,
      String? accountName,
      int? userId,
      String? accountCurrency,
      String? accountCountry}) async {
    var response = await apiManager.updatePaymentInfo(
        accountNumber: accountNumber,
        accountName: accountName,
        accountCountry: accountCountry,
        routingNumber: routingNumber,
        accountCurrency: accountCurrency,
        userId: userId);

    return response.toDto();
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
      String? phone}) async {
    var response = await apiManager.updateProfileWithCheckAccessToken(
      accessToken: accessToken,
      dob: dob,
      address: address,
      city: city,
      country: country,
      postalCode: postalCode,
      ip: ip,
      phone: phone,
    );
    return response.toDto();
  }
}
