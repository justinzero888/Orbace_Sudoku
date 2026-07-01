// Generated from the Firebase console config downloads for the
// "Orbace Sudoku" iOS/Android apps in project stalio-ad9a9.
// Regenerate with `flutterfire configure` if the Firebase project changes.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBx_8nsvhIw8rzryEtOoASNlhfYGLsav2g',
    appId: '1:835435357521:android:2c717ab0a911ab09305f70',
    messagingSenderId: '835435357521',
    projectId: 'stalio-ad9a9',
    storageBucket: 'stalio-ad9a9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDrnrr_DrWafga0uAabrfcZlv30nq5S4F8',
    appId: '1:835435357521:ios:2ba9a2ba99b02a18305f70',
    messagingSenderId: '835435357521',
    projectId: 'stalio-ad9a9',
    storageBucket: 'stalio-ad9a9.firebasestorage.app',
    iosBundleId: 'com.orbace.orbaceSudoku',
  );
}
