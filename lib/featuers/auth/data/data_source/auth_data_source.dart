import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hadawi_app/featuers/auth/data/models/user_model.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/verifiy_otp_code/verifiy_otp_code_screen.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';

abstract class BaseAuthDataSource {
  Future<void> login({required String email, required String password});

  Future<void> register(
      {required String email,
      required String password,
      required String phone,
      required String name,
      required String brithDate,
      required String gender,
      required String city
      });

  Future<void> saveUserData(
      {required String email,
      required String phone,
      required String name,
      required String uId,
      required String brithDate,
      required String gender,
      required String city,
      });


  Future<void> logout();

  Future<void> loginWithGoogle({required String brithDate, required String gender,required String city});

  Future<void> loginWithPhoneNumber({
    required String phone,
    required String email,
    required String name,
    required String brithDate,
    required String gender,
    required String city,
    required bool resendCode,
    required bool isLogin,
    required BuildContext context
  });

  Future<void> verifiyPhoneNumber(
      {
        required String email,
        required String phone,
        required String name,
        required String brithDate,
        required bool isLogin,
        required String verificationId,
        required String verifyOtpPinPut,
        required String gender,
        required String city
      });

  Future<bool> checkUserLogin({required String phoneNumber});
  Future<UserModel>getUserData ({required String uId});
  Future<void>deleteUser ({required String uId});

}

class AuthDataSourceImplement extends BaseAuthDataSource {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final user = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      print(user.user!.uid);
      await getUserData(uId:  user.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptions(firebaseAuthException: e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      UserDataFromStorage.setUid('');
      UserDataFromStorage.setUserName('');
      UserDataFromStorage.setEmail('');
      UserDataFromStorage.setPhoneNumber('');
      UserDataFromStorage.setGender('');
      UserDataFromStorage.setBrithDate('');
      UserDataFromStorage.setUserIsGuest(true);
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
      required String gender,
      required String city,
      }) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await saveUserData(
          email: email,
          phone: phone,
          name: name,
          uId: user.user!.uid,
          brithDate: brithDate,
          city: city,
          gender: gender,
      );
      await getUserData(uId:  user.user!.uid);
    } on FirebaseAuthException catch (e) {
      print('error $e');
      throw FirebaseExceptions(firebaseAuthException: e);
    }
  }

  @override
  Future<void> saveUserData(
      {required String email,
      required String phone,
      required String name,
      required String uId,
      required String brithDate,
      required String gender,
      required String city
      }) async {
    UserModel userModel = UserModel(
        email: email,
        phone: phone,
        name: name,
        uId: uId,
        brithDate: brithDate,
        gender: gender,
        city: city,
        block: false
    );

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
      UserModel userModel = UserModel.fromFire(user.data()!);
      if(userModel.block==true){
        logout();
        throw FirebaseAuthException(code: 'user-blocked');
      }
      UserDataFromStorage.setUserName(userModel.name);
      UserDataFromStorage.setEmail(userModel.email);
      UserDataFromStorage.setPhoneNumber(userModel.phone);
      UserDataFromStorage.setUid(userModel.uId);
      UserDataFromStorage.setGender(userModel.gender);
      UserDataFromStorage.setCity(userModel.city);
      UserDataFromStorage.setBrithDate(userModel.brithDate);
      UserDataFromStorage.setUserIsGuest(false);
      return userModel;
    } on FireStoreException catch (e) {
      throw FireStoreException(firebaseException: e.firebaseException);
    }
  }

  @override
  Future<void> loginWithGoogle(
      {required String brithDate, required String gender, required String city}) async {
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
          city: city,
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
    required String city,
    required bool resendCode,
    required bool isLogin,
    required BuildContext context
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+20${phone.trim()}',
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          if (!kIsWeb && Platform.isIOS) {
            await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
          }
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          if(resendCode==false){
            customPushNavigator(context, VerifyPhoneScreen(
              email: email,
              phone: phone,
              name: name,
              isLogin: isLogin,
              city: city,
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
      required bool isLogin,
      required String verificationId,
      required String verifyOtpPinPut,
      required String city
      }) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: verifyOtpPinPut.trim(),
      );

      try {
        await FirebaseAuth.instance.signInWithCredential(credential)
            .then((value) async {
              if(isLogin==false){
                saveUserData(
                    email: email,
                    phone: phone,
                    name: name,
                    uId: value.user!.uid,
                    brithDate: brithDate,
                    gender: gender,
                  city: city
                );
              }
        });
      } on FirebaseAuthException catch (e) {
        throw FirebaseExceptions(firebaseAuthException: e);
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptions(firebaseAuthException: e);
    }
  }


  @override
  Future<bool> checkUserLogin({required String phoneNumber}) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(phoneNumber).get();
      return true;
    } on FirebaseException catch (error) {
        print('error in happen $error');
        throw FireStoreException(firebaseException: error);
    }
  }

  @override
  Future<void> deleteUser({required String uId})async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      await FirebaseFirestore.instance.collection('users').doc(uId).delete();
    } on FirebaseException catch (error) {
      throw FireStoreException(firebaseException: error);
    }
  }

}
