
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseExceptions implements Exception {

  FirebaseAuthException firebaseAuthException;

  FirebaseExceptions({required this.firebaseAuthException});

}

class FireStoreException implements Exception {

  FirebaseException firebaseException;

  FireStoreException({required this.firebaseException});

}
