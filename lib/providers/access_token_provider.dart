import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccessTokenProvider extends ChangeNotifier {
  String? accessToken, refreshToken;
  AccessTokenProvider() {
    getAccessToken();
    getRefreshToken();
  }

  void getAccessToken() async {
    accessToken = await const FlutterSecureStorage().read(key: 'accessToken');
    notifyListeners();
  }

  void getRefreshToken() async {
    refreshToken = await const FlutterSecureStorage().read(key: 'refreshToken');
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

  void setRefreshToken(String initToken) async {
    print('olddd refresh token $refreshToken');
    refreshToken = initToken;
    print('new refresh token $refreshToken');

    await const FlutterSecureStorage()
        .write(key: 'refreshToken', value: refreshToken);

    notifyListeners();
  }
}
