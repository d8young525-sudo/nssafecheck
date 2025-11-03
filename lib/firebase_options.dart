// Firebase 멀티플랫폼 설정
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

  // Android 설정 (google-services.json에서 추출)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDEIclfVxy-3jymgJosYYa5z_2XTUVMAkM',
    appId: '1:732590262467:android:add054a0f0440dcbce3a76',
    messagingSenderId: '732590262467',
    projectId: 'nssafeflutter',
    storageBucket: 'nssafeflutter.firebasestorage.app',
  );

  // Web 설정 (Firebase Console에서 가져와야 함)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDEIclfVxy-3jymgJosYYa5z_2XTUVMAkM',
    appId: '1:732590262467:web:YOUR_WEB_APP_ID',
    messagingSenderId: '732590262467',
    projectId: 'nssafeflutter',
    storageBucket: 'nssafeflutter.firebasestorage.app',
  );

  // iOS 설정 (필요시 추가)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEIclfVxy-3jymgJosYYa5z_2XTUVMAkM',
    appId: '1:732590262467:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '732590262467',
    projectId: 'nssafeflutter',
    storageBucket: 'nssafeflutter.firebasestorage.app',
    iosBundleId: 'com.company.nssafe',
  );

  // macOS 설정 (필요시 추가)
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDEIclfVxy-3jymgJosYYa5z_2XTUVMAkM',
    appId: '1:732590262467:macos:YOUR_MACOS_APP_ID',
    messagingSenderId: '732590262467',
    projectId: 'nssafeflutter',
    storageBucket: 'nssafeflutter.firebasestorage.app',
    iosBundleId: 'com.company.nssafe',
  );
}
