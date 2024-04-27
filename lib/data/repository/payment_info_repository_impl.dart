import 'package:hatly/domain/datasource/payment_info_datasource.dart';
import 'package:hatly/domain/models/update_payment_info_response_dto.dart';
import 'package:hatly/domain/repository/payment_info_repository.dart';

class PaymentInfoRepositoryImpl implements PaymentInfoRepository {
  PaymentInfoDatasource paymentInfoDatasource;

  PaymentInfoRepositoryImpl(this.paymentInfoDatasource);
  @override
  Future<UpdatePaymentInfoResponseDto> updatePaymentInfo(
      {String? accountNumber,
      String? routingNumber,
      String? accountName,
      int? userId,
      String? accountCurrency,
      String? accountCountry}) {
    return paymentInfoDatasource.updatePaymentInfo(
        accountNumber: accountNumber,
        accountName: accountName,
        accountCountry: accountCountry,
        routingNumber: routingNumber,
        userId: userId,
        accountCurrency: accountCurrency);
  }
}
