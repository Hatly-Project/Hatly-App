import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/domain/datasource/payment_info_datasource.dart';
import 'package:hatly/domain/models/update_payment_info_response_dto.dart';

class PaymentInfoDatasourceImpl implements PaymentInfoDatasource {
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
}
