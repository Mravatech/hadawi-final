import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';

class Faliure extends Equatable{

  final String message;

  const Faliure({required this.message});
  @override
  List<Object?> get props => [message];

}

class FirebaseFaliure extends Faliure{

  const FirebaseFaliure({required super.message});

  factory FirebaseFaliure.fromMessage(FirebaseExceptions error){
    switch(error.firebaseAuthException.code){

      case "invalid-email":
        return FirebaseFaliure(message: "Invalid email");

      case "invalid-phone-number":
        return FirebaseFaliure(message: "Invalid phone number");

      case "invalid-verification-code":
        return FirebaseFaliure(message: "Invalid verification code");

      case "session-expired":
        return FirebaseFaliure(message: "Session expired");

      case "user-not-found":
        return FirebaseFaliure(message: "User not found");

      case "wrong-password":
        return FirebaseFaliure(message: "Wrong password");

      case "user-disabled":
        return FirebaseFaliure(message: "User disabled");

      case "network-request-failed":
        return FirebaseFaliure(message: "Network request failed");

      case "email-already-in-use":
        return FirebaseFaliure(message: "Email already in use");

      case "operation-not-allowed":
        return FirebaseFaliure(message: "Operation not allowed");

      case "weak-password":
        return FirebaseFaliure(message: "Weak password");

      default:
        return FirebaseFaliure(message: error.firebaseAuthException.message!);

    }
  }


}

class GoogleAuthFaliure extends Faliure{

  const GoogleAuthFaliure({required super.message});

  factory GoogleAuthFaliure.fromMessage(FirebaseExceptions error){
    switch(error.firebaseAuthException.code){

      case "account-exists-with-different-credential":
        return GoogleAuthFaliure(message: "Account exists with a different credential. Please use the correct sign-in method");

      case "invalid-credential":
        return GoogleAuthFaliure(message: "Invalid credentials provided.");

      default:
        return GoogleAuthFaliure(message: 'An error occurred: ${error.firebaseAuthException.message}');

    }
  }


}

