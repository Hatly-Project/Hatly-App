import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccessTokenProvider extends ChangeNotifier {
  String? accessToken;
  AccessTokenProvider() {
    getAccessToken();
  }

  void getAccessToken() async {
    accessToken = await const FlutterSecureStorage().read(key: 'accessToken');
  }

  void setAccessToken(String initToken) async {
    accessToken = initToken;
    await const FlutterSecureStorage()
        .write(key: 'accessToken', value: accessToken);

    notifyListeners();
  }
}
