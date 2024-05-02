import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PaymentProvider extends ChangeNotifier {
  String? paymentIntentId, clientSecret;
  // String? dealId;

  // PaymentProvider() {
  //   getPaymentIntentId();
  // }

  void getPaymentIntentId(String? dealId) async {
    paymentIntentId =
        await const FlutterSecureStorage().read(key: 'paymentIntentId-$dealId');
    print('payment intent $paymentIntentId');
    clientSecret =
        await const FlutterSecureStorage().read(key: 'clientSecret-$dealId');
    notifyListeners();
  }

  void setPaymentIntentId(
      String? paymentIntentId, String? clientSecret, String? dealId) async {
    this.paymentIntentId = paymentIntentId;
    this.clientSecret = clientSecret;
    // this.dealId = dealId;
    print('set payment intent $paymentIntentId');
    print('set client secret $clientSecret');

    await const FlutterSecureStorage()
        .write(key: 'paymentIntentId-$dealId', value: this.paymentIntentId);
    await const FlutterSecureStorage()
        .write(key: 'clientSecret-$dealId', value: this.clientSecret);
    notifyListeners();
  }
}
