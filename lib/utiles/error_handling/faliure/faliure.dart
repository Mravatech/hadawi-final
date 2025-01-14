import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Faliure extends Equatable{

  final String message;

  const Faliure({required this.message});

  @override
  List<Object?> get props => [message];

}

class FirebaseFaliure extends Faliure{

  const FirebaseFaliure({required super.message});

  factory FirebaseFaliure.fromMessage(FirebaseAuthException error){
    switch(error.code){

      case "invalid-email":
        return FirebaseFaliure(message: "Invalid email");

      case "user-not-found":
        return FirebaseFaliure(message: "User not found");

      case "wrong-password":
        return FirebaseFaliure(message: "Wrong password");

      case "user-disabled":
        return FirebaseFaliure(message: "User disabled");

      case "email-already-in-use":
        return FirebaseFaliure(message: "Email already in use");

      case "operation-not-allowed":
        return FirebaseFaliure(message: "Operation not allowed");

      case "weak-password":
        return FirebaseFaliure(message: "Weak password");

      default:
        return FirebaseFaliure(message: error.code);

    }
  }


}

