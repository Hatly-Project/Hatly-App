import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMProvider extends ChangeNotifier {
  RemoteNotification? notifMessage;
  String? fcmToken, refreshedToken;
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
      }
      // You can update your app state or perform actions based on the message
      // For example, notify listeners to rebuild UI
      notifMessage = message.notification;
      notifyListeners();
    });
  }

  void setFcmToken(String initFcmToken) {
    fcmToken = initFcmToken;
    notifyListeners();
  }

  void loginAndRefresh() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      var fcmToken = await FirebaseMessaging.instance.getToken();
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
