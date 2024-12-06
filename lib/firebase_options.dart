// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBWK6b-d2iPtYBuCw6R2kkTPhLVOeipM8M',
    appId: '1:592178487205:web:2ef22501d1c2e88e76d24c',
    messagingSenderId: '592178487205',
    projectId: 'mission-0-e2b15',
    authDomain: 'mission-0-e2b15.firebaseapp.com',
    databaseURL: 'https://mission-0-e2b15-default-rtdb.firebaseio.com',
    storageBucket: 'mission-0-e2b15.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOk0-GpN1JQ2-hzLjAw3xs_u4dVyou4To',
    appId: '1:592178487205:android:5d88204dbbfc67e676d24c',
    messagingSenderId: '592178487205',
    projectId: 'mission-0-e2b15',
    databaseURL: 'https://mission-0-e2b15-default-rtdb.firebaseio.com',
    storageBucket: 'mission-0-e2b15.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-LrBAR9x91zmJAlBTVf2066-hnr_r3pQ',
    appId: '1:592178487205:ios:ab786abc85a6dcf476d24c',
    messagingSenderId: '592178487205',
    projectId: 'mission-0-e2b15',
    databaseURL: 'https://mission-0-e2b15-default-rtdb.firebaseio.com',
    storageBucket: 'mission-0-e2b15.firebasestorage.app',
    androidClientId: '592178487205-8r9kof4mv0jeod0a1a9h9fl0r0gs4coi.apps.googleusercontent.com',
    iosClientId: '592178487205-mlno0qp8du02pgdg7d53flc2q0u4pni8.apps.googleusercontent.com',
    iosBundleId: 'com.example.misson0',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB-LrBAR9x91zmJAlBTVf2066-hnr_r3pQ',
    appId: '1:592178487205:ios:ab786abc85a6dcf476d24c',
    messagingSenderId: '592178487205',
    projectId: 'mission-0-e2b15',
    databaseURL: 'https://mission-0-e2b15-default-rtdb.firebaseio.com',
    storageBucket: 'mission-0-e2b15.firebasestorage.app',
    androidClientId: '592178487205-8r9kof4mv0jeod0a1a9h9fl0r0gs4coi.apps.googleusercontent.com',
    iosClientId: '592178487205-mlno0qp8du02pgdg7d53flc2q0u4pni8.apps.googleusercontent.com',
    iosBundleId: 'com.example.misson0',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBWK6b-d2iPtYBuCw6R2kkTPhLVOeipM8M',
    appId: '1:592178487205:web:17982a1b642287b876d24c',
    messagingSenderId: '592178487205',
    projectId: 'mission-0-e2b15',
    authDomain: 'mission-0-e2b15.firebaseapp.com',
    databaseURL: 'https://mission-0-e2b15-default-rtdb.firebaseio.com',
    storageBucket: 'mission-0-e2b15.firebasestorage.app',
  );

}