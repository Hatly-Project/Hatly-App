import 'package:hatly/domain/models/update_payment_info_response_dto.dart';

abstract class PaymentInfoDatasource {
  Future<UpdatePaymentInfoResponseDto> updatePaymentInfo(
      {String? accountNumber,
      String? routingNumber,
      int? userId,
      String? accountName,
      String? accountCurrency,
      String? accountCountry});
}
