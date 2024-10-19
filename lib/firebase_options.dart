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
    apiKey: 'AIzaSyBAv-arH8hu7sm6KyXfattDHa4nyYCb-ts',
    appId: '1:36328857443:web:ac48789a31614f9664fd56',
    messagingSenderId: '36328857443',
    projectId: 'finshorts-c1aed',
    authDomain: 'finshorts-c1aed.firebaseapp.com',
    storageBucket: 'finshorts-c1aed.appspot.com',
    measurementId: 'G-7MPDHX7QTZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCaD6SO-M9A8RF0g8iKWyN13hWm1LOZSp4',
    appId: '1:36328857443:android:c7bfb78b81bc7fb064fd56',
    messagingSenderId: '36328857443',
    projectId: 'finshorts-c1aed',
    storageBucket: 'finshorts-c1aed.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAr48bczvvXfaIx3Eb_untzGLLf2c60KO8',
    appId: '1:36328857443:ios:7e32dabaaa0f80f564fd56',
    messagingSenderId: '36328857443',
    projectId: 'finshorts-c1aed',
    storageBucket: 'finshorts-c1aed.appspot.com',
    androidClientId: '36328857443-n0hmu8t09tnnkqa4vatpme2entc54qsg.apps.googleusercontent.com',
    iosClientId: '36328857443-1sfenblkv7aku22bdc8ebo0lar409e63.apps.googleusercontent.com',
    iosBundleId: 'com.stocknews',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAr48bczvvXfaIx3Eb_untzGLLf2c60KO8',
    appId: '1:36328857443:ios:7e32dabaaa0f80f564fd56',
    messagingSenderId: '36328857443',
    projectId: 'finshorts-c1aed',
    storageBucket: 'finshorts-c1aed.appspot.com',
    androidClientId: '36328857443-n0hmu8t09tnnkqa4vatpme2entc54qsg.apps.googleusercontent.com',
    iosClientId: '36328857443-1sfenblkv7aku22bdc8ebo0lar409e63.apps.googleusercontent.com',
    iosBundleId: 'com.stocknews',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBAv-arH8hu7sm6KyXfattDHa4nyYCb-ts',
    appId: '1:36328857443:web:f60c123df55ca26664fd56',
    messagingSenderId: '36328857443',
    projectId: 'finshorts-c1aed',
    authDomain: 'finshorts-c1aed.firebaseapp.com',
    storageBucket: 'finshorts-c1aed.appspot.com',
    measurementId: 'G-4MTQQ2CF26',
  );

}