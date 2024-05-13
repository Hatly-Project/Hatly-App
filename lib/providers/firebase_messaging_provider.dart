import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/providers/access_token_provider.dart';

class FCMProvider extends ChangeNotifier {
  RemoteNotification? notifMessage;
  String? fcmToken, refreshedToken;
  bool isRefreshed = false, gotMessage = true;
  FCMProvider() {
    _configureFCM();
    refreshToken();
  }

  void _configureFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification?.body}');
        isRefreshed = false;
      }
      // You can update your app state or perform actions based on the message
      // For example, notify listeners to rebuild UI
      notifMessage = message.notification;
      notifyListeners();

      // notifMessage = null;
      // notifyListeners();
    });
  }

  void setFcmToken(String initFcmToken) {
    fcmToken = initFcmToken;
    // isRefreshed = false;
    notifyListeners();
  }

  void loginAndRefresh() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      var fcmToken = await FirebaseMessaging.instance.getToken();
      isRefreshed = true;
      print('fcm Token: $fcmToken');
      setFcmToken(fcmToken!);
    } on Exception catch (e) {
      print('err: $e');
    }
  }

  void refreshToken() async {
    try {
      // await FirebaseMessaging.instance.deleteToken();
      // var fcmToken = await FirebaseMessaging.instance.getToken();
      // print('fcm Token: $fcmToken');
      // setFcmToken(fcmToken!);
      FirebaseMessaging.instance.onTokenRefresh.listen((refreshedFcmToken) {
        // TODO: If necessary send token to application server.
        isRefreshed = true;
        fcmToken = refreshedFcmToken;
        refreshedToken = refreshedFcmToken;

        print('refreshed Token : $fcmToken');
        notifyListeners();
        // Note: This callback is fired at each app startup and whenever a new
        // token is generated.
      }).onError((err) {
        print('error');
        // Error getting token.
      });
    } on Exception catch (e) {
      print('err: $e');
    }
  }
}
