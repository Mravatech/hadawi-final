import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hadawi_app/featuers/auth/data/models/user_model.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:intl/intl.dart';

abstract class BaseAuthDataSource {
  Future<void> login(
      {required String email, required String password, required context, bool isMobileLogin = false});

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
    String firstName = '',
    String lastName = '',
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
      required context,
      bool isMobileLogin = false}) async {
    try {
      if (isMobileLogin) {
        // For mobile login, use custom authentication system
        debugPrint("Mobile login: Using custom authentication system");
        
        // Check if user exists in Firestore by phone number
        final userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: email) // email parameter contains phone number for mobile login
            .limit(1)
            .get();
        
        if (userQuery.docs.isEmpty) {
          debugPrint("User not found in Firestore");
          throw FirebaseExceptions(firebaseAuthException: FirebaseAuthException(code: 'user-not-found'));
        }
        
        final userDoc = userQuery.docs.first;
        final userData = userDoc.data();
        
        // Verify password if provided
        if (password.isNotEmpty && userData['password'] != password) {
          debugPrint("Invalid password");
          throw FirebaseExceptions(firebaseAuthException: FirebaseAuthException(code: 'invalid-credential'));
        }
        
        // Generate custom authentication token
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final random = Random().nextInt(999999);
        final customToken = '${userDoc.id}_${email}_${timestamp}_${random}_custom_auth';
        debugPrint("Generated custom auth token for mobile login");
        
        // Store user data in secure storage
        await UserDataFromStorage.setUid(userDoc.id);
        await UserDataFromStorage.setUserName(userData['name'] ?? '');
        await UserDataFromStorage.setEmail(userData['email'] ?? '');
        await UserDataFromStorage.setPhoneNumber(userData['phone'] ?? '');
        await UserDataFromStorage.setGender(userData['gender'] ?? '');
        await UserDataFromStorage.setBrithDate(userData['brithDate'] ?? '');
        await UserDataFromStorage.setUserIsGuest(false);
        await UserDataFromStorage.setAuthToken(customToken);
        
        debugPrint("Custom mobile login successful");
      } else {
        // For email/password login, use custom authentication system
        debugPrint("Email login: Using custom authentication system");
        
        // Check if user exists in Firestore by email
        final userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        
        if (userQuery.docs.isEmpty) {
          debugPrint("User not found in Firestore");
          throw FirebaseExceptions(firebaseAuthException: FirebaseAuthException(code: 'user-not-found'));
        }
        
        final userDoc = userQuery.docs.first;
        final userData = userDoc.data();
        
        // Verify password
        if (userData['password'] != password) {
          debugPrint("Invalid password");
          throw FirebaseExceptions(firebaseAuthException: FirebaseAuthException(code: 'invalid-credential'));
        }
        
        // Generate custom authentication token
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final random = Random().nextInt(999999);
        final customToken = '${userDoc.id}_${email}_${timestamp}_${random}_custom_auth';
        debugPrint("Generated custom auth token for email login");
        
        // Store user data in secure storage
        await UserDataFromStorage.setUid(userDoc.id);
        await UserDataFromStorage.setUserName(userData['name'] ?? '');
        await UserDataFromStorage.setEmail(userData['email'] ?? '');
        await UserDataFromStorage.setPhoneNumber(userData['phone'] ?? '');
        await UserDataFromStorage.setGender(userData['gender'] ?? '');
        await UserDataFromStorage.setBrithDate(userData['brithDate'] ?? '');
        await UserDataFromStorage.setUserIsGuest(false);
        await UserDataFromStorage.setAuthToken(customToken);
        
        debugPrint("Custom email login successful");
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase login error: ${e.message}");
      throw FirebaseExceptions(firebaseAuthException: e);
    } on Exception catch (e) {
      debugPrint("General login error: $e");
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
      debugPrint("Custom registration: Checking for existing users");
      
      // Check if user already exists by email
      final emailQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      // Check if user already exists by phone (if phone is provided)
      QuerySnapshot phoneQuery;
      if (phone.isNotEmpty) {
        phoneQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: phone)
            .limit(1)
            .get();
      } else {
        // Create empty query snapshot
        phoneQuery = await FirebaseFirestore.instance
            .collection('users')
            .limit(0)
            .get();
      }
      
      if (emailQuery.docs.isNotEmpty) {
        debugPrint("User already exists with this email");
        throw FirebaseExceptions(firebaseAuthException: FirebaseAuthException(code: 'email-already-in-use'));
      }
      
      if (phone.isNotEmpty && phoneQuery.docs.isNotEmpty) {
        debugPrint("User already exists with this phone number");
        throw FirebaseExceptions(firebaseAuthException: FirebaseAuthException(code: 'phone-number-already-exists'));
      }
      
      // Generate a unique user ID for Firestore
      final userId = FirebaseFirestore.instance.collection('users').doc().id;
      debugPrint("Creating new user with ID: $userId");
      
      await saveUserData(
        email: email,
        phone: phone,
        name: name,
        password: password,
        uId: userId,
        brithDate: brithDate,
        city: city,
        gender: gender,
      );
      
      // Generate custom authentication token
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final random = Random().nextInt(999999);
      final customToken = '${userId}_${email}_${timestamp}_${random}_custom_auth';
      debugPrint("Generated custom auth token for new user");
      
      // Store user data in secure storage
      await UserDataFromStorage.setUid(userId);
      await UserDataFromStorage.setUserName(name);
      await UserDataFromStorage.setEmail(email);
      await UserDataFromStorage.setPhoneNumber(phone);
      await UserDataFromStorage.setGender(gender);
      await UserDataFromStorage.setBrithDate(brithDate);
      await UserDataFromStorage.setUserIsGuest(false);
      await UserDataFromStorage.setAuthToken(customToken);
      
      debugPrint("Custom registration successful");
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
      required String city,
      String firstName = '',
      String lastName = ''}) async {
    UserModel userModel = UserModel(
      email: email,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      phone: phone,
      name: name,
      firstName: firstName,
      lastName: lastName,
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
  Future<void> loginWithGoogle({
    required String brithDate,
    required String gender,
    required String city,
    required context
  }) async {
    try {
      // Initialize GoogleSignIn with proper configuration
      final GoogleSignIn googleSignIn = Platform.isIOS
          ? GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId: '1698335350-rn56pn1c22pc1gah4020je52u0oh6it2.apps.googleusercontent.com',
      )
          : GoogleSignIn();

      // Clear previous sign-in state to avoid conflicts
      await googleSignIn.signOut();

      // Start the sign-in flow with error handling
      final GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.signIn();
      } on Exception catch (signInError) {
        print('Google Sign-In error: $signInError');

        // Check if it's a user cancellation (not an actual error)
        if (signInError.toString().contains('sign_in_canceled') ||
            signInError.toString().contains('ERROR_ABORTED_BY_USER')) {
          print('Sign-in cancelled by user');
          return; // Silent return for cancellation
        }

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
          // Extract firstName and lastName from displayName
          String firstName = '';
          String lastName = '';
          String fullName = user.displayName ?? '';
          
          if (fullName.isNotEmpty) {
            List<String> nameParts = fullName.split(' ');
            if (nameParts.isNotEmpty) {
              firstName = nameParts[0];
              if (nameParts.length > 1) {
                lastName = nameParts.sublist(1).join(' ');
              }
            }
          }
          
          await saveUserData(
              email: user.email ?? '',
              phone: '',
              name: fullName,
              uId: user.uid,
              city: city,
              password: '',
              gender: gender,
              brithDate: brithDate,
              firstName: firstName,
              lastName: lastName
          );

          await getUserData(uId: user.uid, context: context);
        } catch (dataError) {
          print('Error saving user data: $dataError');
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
      String pass = '${user.email}';
      String username = pass.split('@')[0];
      print('username $username');

      final numericRegex = RegExp(r'^\d+$');
      if (numericRegex.hasMatch(username)) {
        print('username is numeric');
        // أعد تسجيل الدخول
        AuthCredential credential = EmailAuthProvider.credential(
          email: '${user.email}',
          password: username,
        );

        await user.reauthenticateWithCredential(credential);

        // احذف الحساب بعد التوثيق
        await user.delete();
      }else{

      }


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