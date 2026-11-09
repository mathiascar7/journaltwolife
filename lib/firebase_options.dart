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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Configuración basada en tus datos de Journal2Life
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCC6bsgYbOtmyzIRNt-QvCRbJb1DsSFQ80',
    appId: '1:42977724478:web:cdd765a2b4117cd5f0a96f',
    messagingSenderId: '42977724478',
    projectId: 'journal2life',
    authDomain: 'journal2life.firebaseapp.com',
    storageBucket: 'journal2life.appspot.com',
    measurementId: 'G-RT9J4MFSJY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCC6bsgYbOtmyzIRNt-QvCRbJb1DsSFQ80',
    appId: '1:42977724478:android:7e6d7a2b4117cd5f0a96f', // Generado usualmente por CLI
    messagingSenderId: '42977724478',
    projectId: 'journal2life',
    storageBucket: 'journal2life.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCC6bsgYbOtmyzIRNt-QvCRbJb1DsSFQ80',
    appId: '1:42977724478:ios:8f5e7a2b4117cd5f0a96f', // Generado usualmente por CLI
    messagingSenderId: '42977724478',
    projectId: 'journal2life',
    storageBucket: 'journal2life.appspot.com',
    iosBundleId: 'com.example.journal2life', // Ajusta según tu Bundle ID de Xcode
  );
}