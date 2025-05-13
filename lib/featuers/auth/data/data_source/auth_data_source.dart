import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hadawi_app/featuers/auth/data/models/user_model.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/verifiy_otp_code/verifiy_otp_code_screen.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/services/dio_helper.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:hadawi_app/widgets/toastification_widget.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

abstract class BaseAuthDataSource {
  Future<void> login(
      {required String email, required String password, required context});

  Future<void> register(
      {required String email,
      required String password,
      required String phone,
      required String name,
      required String brithDate,
      required String gender,
      required context,
      required String city});

  Future<void> sendOtp({
    required String phone,
    required int otp,
  });

  Future<void> saveUserData({
    required String email,
    required String phone,
    required String name,
    required String uId,
    required String brithDate,
    required String gender,
    required String city,
    required String password,
  });

  Future<void> logout();

  Future<void> loginWithGoogle(
      {required String brithDate,
      required String gender,
      required String city,
      required context});

  Future<void> loginWithPhoneNumber(
      {required String phone,
      required String email,
      required String name,
      required String brithDate,
      required String gender,
      required String city,
      required bool resendCode,
      required bool isLogin,
      required BuildContext context});

  Future<void> verifiyPhoneNumber(
      {required String email,
      required String phone,
      required String name,
      required String brithDate,
      required String password,
      required bool isLogin,
      required String verificationId,
      required String verifyOtpPinPut,
      required String gender,
      required String city});

  Future<bool> checkUserLogin({required String phoneNumber});

  Future<UserModel> getUserData({required String uId, required context});

  Future<void> deleteUser({required String uId});
}

class AuthDataSourceImplement extends BaseAuthDataSource {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> login(
      {required String email,
      required String password,
      required context}) async {
    try {
      final user = await firebaseAuth.signInWithEmailAndPassword(
          email: '$email@gmail.com', password: email);
      print(user.user!.uid);

      await getUserData(uId: user.user!.uid, context: context);
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptions(firebaseAuthException: e);
    } on Exception catch (e) {
      throw Exception(e.toString());
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
      UserDataFromStorage.setGradeAdmin(false);
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptions(firebaseAuthException: e);
    }
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String phone,
    required String name,
    required String brithDate,
    required String gender,
    required context,
    required String city,
  }) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
          email: '$phone@gmail.com', password: phone);
      await saveUserData(
        email: email,
        phone: phone,
        name: name,
        password: password,
        uId: user.user!.uid,
        brithDate: brithDate,
        city: city,
        gender: gender,
      );
      await getUserData(uId: user.user!.uid, context: context);
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
      required String password,
      required String city}) async {
    UserModel userModel = UserModel(
      email: email,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      phone: phone,
      name: name,
      token: '',
      uId: uId,
      brithDate: brithDate,
      gender: gender,
      city: city,
      password: password,
      block: false,
      private: false,
    );

    try {
      await firestore.collection('users').doc(uId).set(userModel.toMap());
    } on FireStoreException catch (e) {
      throw FireStoreException(firebaseException: e.firebaseException);
    }
  }

  @override
  Future<UserModel> getUserData({required String uId, required context}) async {
    try {
      final user = await firestore.collection('users').doc(uId).get();
      if (user.data() == null) {
        throw FireStoreException(
            firebaseException: FirebaseAuthException(code: 'user-not-found'));
      }
      UserModel userModel = UserModel.fromFire(user.data()!);
      if (userModel.block == true) {
        UserDataFromStorage.setUserBlocked(true);
        logout();
      } else {
        UserDataFromStorage.setUserBlocked(false);
      }
      UserDataFromStorage.setUserName(userModel.name);
      UserDataFromStorage.setEmail(userModel.email);
      if (userModel.phone == '') {
        UserDataFromStorage.setPhoneNumber('');
      } else {
        UserDataFromStorage.setPhoneNumber(userModel.phone);
      }
      UserDataFromStorage.setPhoneNumber(
          userModel.phone == '' ? '' : userModel.phone);
      UserDataFromStorage.setUid(userModel.uId);
      UserDataFromStorage.setGender(userModel.gender);
      UserDataFromStorage.setCity(userModel.city);
      UserDataFromStorage.setBrithDate(userModel.brithDate);
      UserDataFromStorage.setUserIsGuest(false);
      UserDataFromStorage.setPrivateAccount(userModel.private);
      print('Uid ${UserDataFromStorage.uIdFromStorage}');
      return userModel;
    } on FireStoreException catch (e) {
      print('error here $e');
      UserDataFromStorage.setUid('');
      throw FireStoreException(firebaseException: e.firebaseException);
    } on Exception catch (e) {
      print('error in getUserData $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> loginWithGoogle(
      {required String brithDate,
        required String gender,
        required String city,
        required context}) async {
    try {
      // Initialize GoogleSignIn with proper configuration
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        // Add this line to explicitly specify client ID for iOS
        clientId: '1698335350-rn56pn1c22pc1gah4020je52u0oh6it2.apps.googleusercontent.com',
      );

      // Clear previous sign-in state to avoid conflicts
      await googleSignIn.signOut();

      // Start the sign-in flow with error handling
      final GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.signIn();
      } catch (signInError) {
        print('Google Sign-In error: $signInError');
        throw Exception('Failed to initiate Google Sign-In: $signInError');
      }

      // Handle case where user cancels the sign-in
      if (googleUser == null) {
        print('Sign-in cancelled by user');
        return; // Return without error - user simply cancelled
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth;
      try {
        googleAuth = await googleUser.authentication;
      } catch (authError) {
        print('Google Auth error: $authError');
        throw Exception('Failed to authenticate with Google: $authError');
      }

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('--------------');
      print('Signing in to Firebase with Google credential...');

      // Sign in to Firebase with credential
      final UserCredential userCredential;
      try {
        userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      } catch (firebaseError) {
        print('Firebase sign-in error: $firebaseError');
        throw Exception('Failed to sign in to Firebase: $firebaseError');
      }

      final user = userCredential.user;
      print('${user?.email ?? "No email"}, ${user?.displayName ?? "No name"}, ${user?.uid}');
      print('--------------');

      // Only proceed if we have a user
      if (user != null) {
        try {
          await saveUserData(
              email: user.email ?? '',
              phone: '',
              name: user.displayName ?? '',
              uId: user.uid,
              city: city,
              password: '',
              gender: gender,
              brithDate: brithDate
          );

          await getUserData(uId: user.uid, context: context);
        } catch (dataError) {
          print('Error saving user data: $dataError');
          // Consider if you want to throw here or just log the error
          throw Exception('Failed to save user data: $dataError');
        }
      } else {
        throw Exception('Failed to get user information after authentication');
      }
    } on FirebaseAuthException catch (firebaseAuthException) {
      print('FirebaseAuthException: ${firebaseAuthException.message}');
      throw FirebaseExceptions(firebaseAuthException: firebaseAuthException);
    } catch (e) {
      print('General exception: $e');
      throw Exception('Authentication failed: ${e.toString()}');
    }
  }


  @override
  Future<void> loginWithPhoneNumber(
      {required String phone,
      required String email,
      required String name,
      required String brithDate,
      required String gender,
      required String city,
      required bool resendCode,
      required bool isLogin,
      required BuildContext context}) async {
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
          if (resendCode == false) {
            // customPushNavigator(
            //     context,
            //     VerifyPhoneScreen(
            //       email: email,
            //       phone: phone,
            //       name: name,
            //       city: city,
            //       brithDate: brithDate,
            //       gender: gender,
            //       verificationOtp: verificationId,
            //     ));
          }
        },
        verificationFailed: (FirebaseAuthException exception) async {
          if (resendCode == false) {
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
            }
          }
        },
        codeAutoRetrievalTimeout: (e) {},
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptions(firebaseAuthException: e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> verifiyPhoneNumber(
      {required String email,
      required String phone,
      required String name,
      required String brithDate,
      required String password,
      required String gender,
      required bool isLogin,
      required String verificationId,
      required String verifyOtpPinPut,
      required String city}) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: verifyOtpPinPut.trim(),
      );

      try {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (isLogin == false) {
            saveUserData(
                email: email,
                phone: phone,
                name: name,
                password: password,
                uId: value.user!.uid,
                brithDate: brithDate,
                gender: gender,
                city: city);
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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(phoneNumber)
          .get();
      return true;
    } on FirebaseException catch (error) {
      print('error in happen $error');
      throw FireStoreException(firebaseException: error);
    }
  }

  @override
  Future<void> deleteUser({required String uId}) async {
    try {
      print('Uid $uId');
      final user = FirebaseAuth.instance.currentUser!;
      print('phone ${user.email}');
      print('pass ${UserDataFromStorage.macAddressFromStorage}');
      String pass = '127755643@gmail.com';
      String username = pass.split('@')[0];
      print('username $username');

      // أعد تسجيل الدخول
      AuthCredential credential = EmailAuthProvider.credential(
        email: '${user.email}',
        password: username,
      );

      await user.reauthenticateWithCredential(credential);

      // احذف الحساب بعد التوثيق
      await user.delete();
      await FirebaseFirestore.instance.collection('users').doc(uId).delete();
      await UserDataFromStorage.removeAllDataFromStorage();
    } on FirebaseException catch (error) {
      throw FireStoreException(firebaseException: error);
    }
  }

  @override
  Future<Either<Failure, Unit>> sendOtp({required String phone, required int otp,}) async {
    try {
      String formattedPhone = phone.startsWith('+') ? phone : '+966$phone';
      print('Sending OTP to: $formattedPhone, OTP: $otp');

      final response = await Dio().post(
        'https://api.oursms.com/msgs/sms',
        options: Options(
          headers: {
            'Authorization': 'Bearer hDkbbkGMLVpt2ZLN4oLa',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "src": "hadawi",
          "dests": [formattedPhone],
          "body": "مرحباً بك في هداوي\n استخدم هذا الكود $otp للتحقق من رقم هاتفك"
        },
      );

      if (response.statusCode == 200) {
        print('OTP sent successfully');
        return const Right(unit);
      } else {
        print('Unexpected status code: ${response.statusCode}, Data: ${response.data}');
        return Left(Failure(message: 'Unexpected status code: ${response.statusCode}'));
      }
    } catch (e) {
      if (e is DioException) {
        print('DioException: ${e.message}, Status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        return Left(Failure(message: e.response?.data['message'] ?? 'Error sending OTP: ${e.message}'));
      }
      print('Unexpected error: $e');
      return Left(Failure(message: 'Unexpected error: $e'));
    }
  }}
class Failure {
  final String message;
  Failure({required this.message});
}