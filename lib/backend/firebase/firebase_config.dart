import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDd7SFrRI9GS2hRK_BmT8fd1mJyRFb_iOs",
            authDomain: "aggieville-pickup-sigma-chi.firebaseapp.com",
            projectId: "aggieville-pickup-sigma-chi",
            storageBucket: "aggieville-pickup-sigma-chi.firebasestorage.app",
            messagingSenderId: "677144751572",
            appId: "1:677144751572:web:8fd1a5499ee0178cb9ba41"));
  } else {
    await Firebase.initializeApp();
  }
}
