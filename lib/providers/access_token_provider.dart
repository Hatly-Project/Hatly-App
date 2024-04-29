import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccessTokenProvider extends ChangeNotifier {
  String? accessToken;
  AccessTokenProvider() {
    getAccessToken();
  }

  void getAccessToken() async {
    accessToken = await const FlutterSecureStorage().read(key: 'accessToken');
    notifyListeners();
  }

  void setAccessToken(String initToken) async {
    print('olddd $accessToken');
    accessToken = initToken;
    print('new $accessToken');

    await const FlutterSecureStorage()
        .write(key: 'accessToken', value: accessToken);

    notifyListeners();
  }
}
