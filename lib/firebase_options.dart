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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBNpw0LmnoJRNfAOnAUeC1ir6O28HAq9MU',
    appId: '1:738824982963:web:87b1bacbae08469cd47bc6',
    messagingSenderId: '738824982963',
    projectId: 'mobile-1a26a',
    authDomain: 'mobile-1a26a.firebaseapp.com',
    storageBucket: 'mobile-1a26a.appspot.com',
    measurementId: 'G-E6X18F6NXJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBB7D1uyA5nr0BzQgY1vAysHU8j0JLx8PY',
    appId: '1:738824982963:android:a64273a92eb4cb8ad47bc6',
    messagingSenderId: '738824982963',
    projectId: 'mobile-1a26a',
    storageBucket: 'mobile-1a26a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAfBtkxLaOKFCF5TKs3WnN98zZJnEzSEQ0',
    appId: '1:738824982963:ios:a6903c7af58fe159d47bc6',
    messagingSenderId: '738824982963',
    projectId: 'mobile-1a26a',
    storageBucket: 'mobile-1a26a.appspot.com',
    iosBundleId: 'com.example.mobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAfBtkxLaOKFCF5TKs3WnN98zZJnEzSEQ0',
    appId: '1:738824982963:ios:23e07d23f8fcdf26d47bc6',
    messagingSenderId: '738824982963',
    projectId: 'mobile-1a26a',
    storageBucket: 'mobile-1a26a.appspot.com',
    iosBundleId: 'com.example.mobile.RunnerTests',
  );
}
