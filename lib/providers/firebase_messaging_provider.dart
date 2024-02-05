import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMProvider extends ChangeNotifier {
  RemoteNotification? notifMessage;
  FCMProvider() {
    _configureFCM();
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
}
