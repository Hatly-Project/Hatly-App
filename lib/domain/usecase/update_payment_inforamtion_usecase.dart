import 'package:hatly/domain/models/update_payment_info_response_dto.dart';
import 'package:hatly/domain/repository/payment_info_repository.dart';

class UpdatePaymentInformationUsecase {
  PaymentInfoRepository repository;

  UpdatePaymentInformationUsecase(this.repository);

  Future<UpdatePaymentInfoResponseDto> updatePaymentInfo(
      {String? accountNumber,
      String? routingNumber,
      String? accountName,
      String? accountCurrency,
      String? accountCountry,
      int? userid}) {
    return repository.updatePaymentInfo(
        accountNumber: accountNumber,
        accountName: accountName,
        routingNumber: routingNumber,
        userId: userid,
        accountCountry: accountCountry,
        accountCurrency: accountCurrency);
  }
}
