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
    apiKey: 'AIzaSyDIJd7gSwJYeo4DpvE3nXQBvslX2No4BLo',
    appId: '1:40760471493:web:311489764dedf8fcb5a5ac',
    messagingSenderId: '40760471493',
    projectId: 'twitter-clone-bf84d',
    authDomain: 'twitter-clone-bf84d.firebaseapp.com',
    storageBucket: 'twitter-clone-bf84d.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDMkcg8hMrNv7NfaJvnbEMARoyWQBH6VEs',
    appId: '1:40760471493:android:d7ce6d2c91eaea41b5a5ac',
    messagingSenderId: '40760471493',
    projectId: 'twitter-clone-bf84d',
    storageBucket: 'twitter-clone-bf84d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5bnA5YsD5HQjTF_qF1z9Zp2tG68tTq6U',
    appId: '1:40760471493:ios:830de60aebab5e31b5a5ac',
    messagingSenderId: '40760471493',
    projectId: 'twitter-clone-bf84d',
    storageBucket: 'twitter-clone-bf84d.firebasestorage.app',
    iosBundleId: 'com.example.twitterClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5bnA5YsD5HQjTF_qF1z9Zp2tG68tTq6U',
    appId: '1:40760471493:ios:830de60aebab5e31b5a5ac',
    messagingSenderId: '40760471493',
    projectId: 'twitter-clone-bf84d',
    storageBucket: 'twitter-clone-bf84d.firebasestorage.app',
    iosBundleId: 'com.example.twitterClone',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDIJd7gSwJYeo4DpvE3nXQBvslX2No4BLo',
    appId: '1:40760471493:web:95393db9dd6c336cb5a5ac',
    messagingSenderId: '40760471493',
    projectId: 'twitter-clone-bf84d',
    authDomain: 'twitter-clone-bf84d.firebaseapp.com',
    storageBucket: 'twitter-clone-bf84d.firebasestorage.app',
  );

}