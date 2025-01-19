import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hadawi_app/featuers/auth/data/models/user_model.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/verifiy_otp_code/verifiy_otp_code_screen.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/widgets/toast.dart';

abstract class BaseAuthDataSource {
  Future<void> login({required String email, required String password});

  Future<void> register(
      {required String email,
      required String password,
      required String phone,
      required String name,
      required String brithDate,
      required String gender});

  Future<void> saveUserData(
      {required String email,
      required String phone,
      required String name,
      required String uId,
      required String brithDate,
      required String gender});

  Future<UserModel> getUserData({
    required String uId,
  });

  Future<void> logout();

  Future<void> loginWithGoogle(
      {required String brithDate, required String gender});

  Future<void> loginWithPhoneNumber({
    required String phone,
    required String email,
    required String name,
    required String brithDate,
    required String gender,
    required bool resendCode,
    required BuildContext context
  });

  Future<void> verifiyPhoneNumber(
      {
        required String email,
        required String phone,
        required String name,
        required String brithDate,
        required String verificationId,
        required String verifyOtpPinPut,
        required String gender
      });
}

class AuthDataSourceImplement extends BaseAuthDataSource {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptions(firebaseAuthException: e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptions(firebaseAuthException: e);
    }
  }

  @override
  Future<void> register(
      {required String email,
      required String password,
      required String phone,
      required String name,
      required String brithDate,
      required String gender}) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
          email: '$phone@gmail.com', password: password);
      saveUserData(
          email: email,
          phone: phone,
          name: name,
          uId: user.user!.uid,
          brithDate: brithDate,
          gender: gender);
    } on FirebaseAuthException catch (e) {
      print('error $e');
      throw FirebaseExceptions(firebaseAuthException: e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> saveUserData(
      {required String email,
      required String phone,
      required String name,
      required String uId,
      required String brithDate,
      required String gender}) async {
    UserModel userModel = UserModel(
        email: email,
        phone: phone,
        name: name,
        uId: uId,
        brithDate: brithDate,
        gender: gender);

    try {
      await firestore.collection('users').doc(uId).set(userModel.toMap());
    } on FireStoreException catch (e) {
      throw FireStoreException(firebaseException: e.firebaseException);
    }
  }

  @override
  Future<UserModel> getUserData({required String uId}) async {
    try {
      final user = await firestore.collection('users').doc(uId).get();
      return UserModel.fromFire(user.data()!);
    } on FireStoreException catch (e) {
      throw FireStoreException(firebaseException: e.firebaseException);
    }
  }

  @override
  Future<void> loginWithGoogle(
      {required String brithDate, required String gender}) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final user = await firebaseAuth.signInWithCredential(credential);
      saveUserData(
          email: user.user!.email!,
          phone: '',
          name: user.user!.displayName!,
          uId: user.user!.uid,
          brithDate: brithDate,
          gender: gender);
    } on FirebaseAuthException catch (firebaseAuthException) {
      throw FirebaseExceptions(firebaseAuthException: firebaseAuthException);
    }
  }

  @override
  Future<void> loginWithPhoneNumber({
    required String phone,
    required String email,
    required String name,
    required String brithDate,
    required String gender,
    required bool resendCode,
    required BuildContext context
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+20${phone.trim()}',
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          if (!kIsWeb && Platform.isIOS) {
            await FirebaseAuth.instance
                .signInWithCredential(phoneAuthCredential);
          }
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          if(resendCode==false){
            customPushNavigator(context, VerifyPhoneScreen(
              email: email,
              phone: phone,
              name: name,
              brithDate: brithDate,
              gender: gender,
              verificationId: verificationId,
            ));
          }

        },
        verificationFailed: (FirebaseAuthException exception) async {
          if(resendCode==false){
            if (exception.code == 'invalid-phone-number') {
              customToast(
                  title: ' Please enter a valid phone number',
                  color: ColorManager.error);
            } else if (exception.code == 'network-request-failed') {
              customToast(
                  title: 'Please check your internet connection',
                  color: ColorManager.error);
            } else if (exception.code == 'phone-number-already-exists') {
              customToast(
                  title: 'Phone number already exists',
                  color: ColorManager.error);
            } else {
              customToast(title: exception.code, color: ColorManager.error);
            }
          }

        },
        codeAutoRetrievalTimeout: (e) {
        },
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptions(firebaseAuthException: e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> verifiyPhoneNumber(
      {
      required String email,
      required String phone,
      required String name,
      required String brithDate,
      required String gender,
      required String verificationId,
      required String verifyOtpPinPut,
      }) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: verifyOtpPinPut.trim(),
      );

      try {
        await FirebaseAuth.instance.signInWithCredential(credential)
            .then((value) async {
          saveUserData(
              email: email,
              phone: phone,
              name: name,
              uId: value.user!.uid,
              brithDate: brithDate,
              gender: gender
          );
        });
      } on FirebaseAuthException catch (e) {
        throw FirebaseExceptions(firebaseAuthException: e);
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptions(firebaseAuthException: e);
    }
  }
}
