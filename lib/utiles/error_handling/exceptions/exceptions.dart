
import 'package:cloud_firestore/cloud_firestore.dart';

class ServerExceptions implements Exception {

  FirebaseException firebaseException;

  ServerExceptions({required this.firebaseException});

}