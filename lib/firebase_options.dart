// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1WHkeQYacFCyJjBaz_-HFqZROrqCekj0',
    appId: '1:445303705925:android:8191de8fafa01ecf04ee2c',
    messagingSenderId: '445303705925',
    projectId: 'hatly-100dc',
    storageBucket: 'hatly-100dc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCexxbjciqkvH0c9ae8-QzzIvhaBhwPdFk',
    appId: '1:445303705925:ios:0d3653b4d1918bf504ee2c',
    messagingSenderId: '445303705925',
    projectId: 'hatly-100dc',
    storageBucket: 'hatly-100dc.appspot.com',
    androidClientId:
        '445303705925-mlnjpvric7d0bia56e5i92biiaghnotu.apps.googleusercontent.com',
    iosClientId:
        '445303705925-6sh98frk7v49858seg60bn7u9t25srbl.apps.googleusercontent.com',
    iosBundleId: 'com.hatly.hatly-user',
  );
}
