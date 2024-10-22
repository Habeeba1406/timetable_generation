// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
    apiKey: 'AIzaSyDkxaRG9lQhp9nZEC9uxoSsT6kINaXeUwM',
    appId: '1:168466748537:web:0c67861bba9ecd6acbf0a8',
    messagingSenderId: '168466748537',
    projectId: 'timetable-bd0b6',
    authDomain: 'timetable-bd0b6.firebaseapp.com',
    storageBucket: 'timetable-bd0b6.appspot.com',
    measurementId: 'G-07CWGSF5ZE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCihVfAZbwQrRr-lAoBUm3BN23Z-VBi0KM',
    appId: '1:168466748537:android:71f2586c9bbe2c04cbf0a8',
    messagingSenderId: '168466748537',
    projectId: 'timetable-bd0b6',
    storageBucket: 'timetable-bd0b6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMF_JAyOFeHVaKLmfD1Gx69qf9fdWGGeQ',
    appId: '1:168466748537:ios:06e24722c764527bcbf0a8',
    messagingSenderId: '168466748537',
    projectId: 'timetable-bd0b6',
    storageBucket: 'timetable-bd0b6.appspot.com',
    iosBundleId: 'com.example.timetableGeneration',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMF_JAyOFeHVaKLmfD1Gx69qf9fdWGGeQ',
    appId: '1:168466748537:ios:06e24722c764527bcbf0a8',
    messagingSenderId: '168466748537',
    projectId: 'timetable-bd0b6',
    storageBucket: 'timetable-bd0b6.appspot.com',
    iosBundleId: 'com.example.timetableGeneration',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDkxaRG9lQhp9nZEC9uxoSsT6kINaXeUwM',
    appId: '1:168466748537:web:19bcf51888a9412ecbf0a8',
    messagingSenderId: '168466748537',
    projectId: 'timetable-bd0b6',
    authDomain: 'timetable-bd0b6.firebaseapp.com',
    storageBucket: 'timetable-bd0b6.appspot.com',
    measurementId: 'G-1KSEB48YQW',
  );
}
