import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/data/models/user_model.dart';
import 'package:hadawi_app/featuers/auth/domain/entities/user_entities.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/check_user_login_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/delete_user_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/get_user_info_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/google_auth_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/login_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/login_with_phone_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/logout.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/register_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/save_data_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/verifiy_code_use_cases.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit(
    this.loginUseCases,
    this.registerUseCases,
    this.saveDataUseCases,
    this.logoutUseCases,
    this.googleAuthUseCases,
    this.loginWithPhoneUseCases,
    this.verifiyCodeUseCases,
    this.getUserInfoUseCases,
    this.checkUserLoginUseCases,
    this.deleteUserUseCases,
  ) : super(AuthInitialState());

  LoginUseCases loginUseCases;
  RegisterUseCases registerUseCases;
  SaveDataUseCases saveDataUseCases;
  LogoutUseCases logoutUseCases;
  GoogleAuthUseCases googleAuthUseCases;
  LoginWithPhoneUseCases loginWithPhoneUseCases;
  VerifiyCodeUseCases verifiyCodeUseCases;
  GetUserInfoUseCases getUserInfoUseCases;
  CheckUserLoginUseCases checkUserLoginUseCases;
  DeleteUserUseCases deleteUserUseCases;

  String dropdownCity = "";
  List<String> saudiCities = [
    // منطقة الرياض
    "الرياض", "الدرعية", "الخرج", "الدوادمي", "المجمعة", "الزلفي", "شقراء",
    "وادي الدواسر", "الأفلاج", "عفيف", "حوطة بني تميم", "السليل", "ثادق",
    "حريملاء", "رماح", "المزاحمية", "ضرماء", "مرات",

    // منطقة مكة المكرمة
    "مكة المكرمة", "جدة", "الطائف", "رابغ", "الليث", "القنفذة", "الخرمة",
    "الكامل", "خليص", "الجموم", "رنية", "تربة",

    // منطقة المدينة المنورة
    "المدينة المنورة", "ينبع", "العلا", "بدر", "الحناكية", "خيبر", "المهد",

    // المنطقة الشرقية
    "الدمام", "الخبر", "الظهران", "الجبيل", "القطيف", "الأحساء", "رأس تنورة",
    "الخفجي", "النعيرية", "حفر الباطن", "قرية العليا", "بقيق",

    // منطقة القصيم
    "بريدة", "عنيزة", "الرس", "المذنب", "البكيرية", "البدائع", "الأسياح",
    "النبهانية", "عيون الجواء", "رياض الخبراء", "الشماسية",

    // منطقة عسير
    "أبها", "خميس مشيط", "بيشة", "محايل عسير", "النماص", "رجال ألمع",
    "سراة عبيدة", "ظهران الجنوب", "تثليث", "أحد رفيدة", "المجاردة", "البرك",

    // منطقة حائل
    "حائل", "بقعاء", "الشنان", "الغزالة", "الحائط", "السليمي", "سميراء",

    // منطقة تبوك
    "تبوك", "الوجه", "ضباء", "أملج", "حقل", "البدع",

    // منطقة نجران
    "نجران", "شرورة", "حبونا", "يدمة", "بدر الجنوب", "ثار", "خباش",

    // منطقة جازان
    "جازان", "صبيا", "أبو عريش", "صامطة", "فرسان", "العارضة", "الداير بني مالك",
    "أحد المسارحة", "بيش", "العيدابي", "الدرب", "الحرث",

    // منطقة الباحة
    "الباحة", "بلجرشي", "المندق", "المخواة", "العقيق", "قلوة",

    // منطقة الجوف
    "سكاكا", "القريات", "دومة الجندل",

    // منطقة الحدود الشمالية
    "عرعر", "رفحاء", "طريف"
  ];

  static AuthCubit get(context) => BlocProvider.of(context);

  TextEditingController brithDateController = TextEditingController();

  Future<void> login(
      {required String email,
      required String password,
      required context}) async {
    emit(UserLoginLoadingState());
    try {
      final result = await loginUseCases.login(
          email: email, password: password, context: context);
      result.fold((l) {
        emit(UserLoginErrorState(message: l.message));
      }, (r) {
        emit(UserLoginSuccessState());
      });
    } catch (e) {
      emit(UserLoginErrorState(message: 'تم حذف الحساب'));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String phone,
    required String name,
    required context,
    required String brithDate,
    required String gender,
    required String city,
  }) async {
    emit(UserRegisterLoadingState());
    final result = await registerUseCases.register(
        email: email,
        password: password,
        brithDate: brithDate,
        gender: gender,
        name: name,
        context: context,
        phone: phone,
        city: city);
    result.fold((l) {
      debugPrint('Register Error**********${l.message}');
      emit(UserRegisterErrorState(message: l.message));
    }, (r) {
      debugPrint('Register Success**********');
      emit(UserRegisterSuccessState());
    });
  }

  String otpCode = '';
  String generateRandomCode({int length = 6}) {
    const String chars =
        '0123456789';
    final Random random = Random();
    final String code =
    List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
    otpCode = code;
    debugPrint("Generated Code: $code");
    emit(GenerateCodeSuccessState());
    return code;
  }

  Future<void> sendOtp({required String phone,}) async {
    emit(SendOtpLoadingState());
    try {
      if (phone.isEmpty) {
        emit(SendOtpErrorState(message: 'Phone number is required'));
        return;
      }
      if (otpCode.isEmpty || !RegExp(r'^\d+$').hasMatch(otpCode)) {
        emit(SendOtpErrorState(message: 'Invalid OTP code'));
        return;
      }

      final parsedOtp = int.parse(otpCode);
      final result = await registerUseCases.sendOtp(phone: phone, otp: parsedOtp, );

      result.fold((l) {
        emit(SendOtpErrorState(message: l.message));
      }, (r) {
        customToast(title: 'تم ارسال كود التحقق', color: ColorManager.primaryBlue);
        emit(SendOtpSuccessState());
      });
    } catch (e) {
      debugPrint('Unexpected error in sendOtp: $e');
      emit(SendOtpErrorState(message: 'Unexpected error: $e'));
    }
  }
  void verifyOtp({required int otp}) {
    emit(VerifiyOtpCodeLoadingState());
    if (otp == int.parse(otpCode)) {
      emit(VerifiyOtpCodeSuccessState());
    } else {
      emit(VerifiyOtpCodeErrorState(message: 'Invalid OTP code'));
    }
  }
  Future<void> saveUserData(
      {required String uId,
      required String email,
      required String phone,
      required String name,
      required String brithDate,
      required String gender,
      required String password,
      required String city}) async {
    emit(UserSaveDataLoadingState());
    final result = await saveDataUseCases.saveUserData(
        uId: uId,
        email: email,
        phone: phone,
        name: name,
        brithDate: brithDate,
        password: password,
        gender: gender,
        city: city);
    result.fold((l) {
      emit(UserSaveDataErrorState(message: l.message));
    }, (r) {
      emit(UserSaveDataSuccessState());
    });
  }

  Future<void> logout() async {
    emit(UserLogoutLoadingState());
    final result = await logoutUseCases.logout();
    result.fold((l) {
      emit(UserLogoutErrorState(message: l.message));
    }, (r) {
      emit(UserLogoutSuccessState());
    });
  }

  Future<void> deleteUser() async {
    emit(DeleteUserLoadingState());
    final result = await deleteUserUseCases.deleteUser(
        uId: UserDataFromStorage.uIdFromStorage);
    result.fold((l) {
      emit(DeleteUserErrorState(message: l.message));
    }, (r) {
      emit(DeleteUserSuccessState());
    });
  }

  void setBrithDate({required DateTime brithDateValue}) {
    brithDateController.text = DateFormat('yyyy-MM-dd').format(brithDateValue);
    emit(SetBrithDayValueState());
  }

  Future<void> signInWithGoogle(
      {required String brithDate,
      required String gender,
      required BuildContext context,
      required String city}) async {
    emit(SignInWithSocialMediaLoadingState());
    try {
      final result = await googleAuthUseCases.loginWithGoogle(
          brithDate: brithDate, gender: gender, city: city,context: context);
      result.fold((l) {
        emit(SignInWithSocialMediaErrorState(message: l.message));
      }, (r) {
        customToast(title: 'تم التسجيل', color: ColorManager.primaryBlue);
        emit(SignInWithSocialMediaSuccessState());
      });
    } catch (e) {
      emit(SignInWithSocialMediaErrorState(message: ''));
    }
  }

  String genderValue = 'Male';

  void changeGenderValue(String? value) {
    genderValue = value!;
    print(genderValue);
    emit(SelectGenderTypeState());
  }

  bool isLoading = false;

  Future<void> loginWithPhone(
      {required String phone,
      required String email,
      required String name,
      required String brithDate,
      required String gender,
      required String city,
      required bool resendCode,
      required bool isLogin,
      required BuildContext context}) async {
    isLoading = true;
    emit(LoginWithPhoneLoadingState());
    final result = await loginWithPhoneUseCases.call(
        context: context,
        phone: phone,
        email: email,
        name: name,
        resendCode: resendCode,
        isLogin: isLogin,
        brithDate: brithDate,
        gender: gender,
        city: city);
    result.fold((l) {
      isLoading = false;
      emit(LoginWithPhoneErrorState(message: l.message));
    }, (r) async {
      isLoading = false;
      emit(LoginWithPhoneSuccessState());
    });
  }

  Future<void> verifiyOtpCode({
    required String email,
    required String phone,
    required String name,
    required String brithDate,
    required String gender,
    required String city,
    required String verificationId,
    required bool isLogin,
    required String verifyOtpPinPut,
  }) async {
    emit(VerifiyOtpCodeLoadingState());

    final result = await verifiyCodeUseCases.call(
        email: email,
        phone: phone,
        name: name,
        brithDate: brithDate,
        gender: gender,
        city: city,
        isLogin: isLogin,
        verificationId: verificationId,
        verifyOtpPinPut: verifyOtpPinPut);

    result.fold((l) {
      emit(VerifiyOtpCodeErrorState(message: l.message));
    }, (r) {
      customToast(title: 'تم التحقق', color: ColorManager.primaryBlue);
      emit(VerifiyOtpCodeSuccessState());
    });
  }

  int second = 0;
  Timer? secondTimer;
  bool resendButton = false;

  resendOtpTimer() {
    second = 31;
    secondTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (second > 0) {
        --second;
        emit(ResendCodeTimerState());
      } else {
        resendButton = true;
        second = 0;
        secondTimer!.cancel();
        emit(ResendCodeTimerFinishedState());
      }
    });
  }

  Future<void> getUserInfo({required String uId, required context}) async {
    emit(GetUserDataLoadingState());
    try {
      final result =
          await getUserInfoUseCases.getUserInfo(uId: uId, context: context);
      result.fold((l) => emit(GetUserDataErrorState(message: l.message)), (r) {
        emit(GetUserDataSuccessState());
      });
    } catch (e) {
      print('error in getUserInfo $e');
      emit(GetUserDataErrorState(message: 'تم حذف الحساب من قبل الاداره'));
    }
  }

  Future<void> checkUserLogin({required String phoneNumber}) async {
    emit(CheckUserLoadingState());
    final result =
        await checkUserLoginUseCases.checkUserLogin(phoneNumber: phoneNumber);
    result.fold((l) => emit(CheckUserErrorState(message: l.message)), (r) {
      emit(CheckUserSuccessState());
    });
  }

  Future<void> resetPassword({required String email}) async {
    emit(ResetPasswordLoadingState());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(ResetPasswordSuccessState());
    } catch (e) {
      debugPrint("error in reset password: $e");
      emit(ResetPasswordErrorState(message: e.toString()));
    }
  }

  Future<void> signInWithApple() async {
    emit(SignInWithSocialMediaLoadingState());
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      // Handle null or empty name from Apple
      String userName = "Apple User"; // Default name
      if (credential.givenName != null && credential.familyName != null) {
        userName = "${credential.givenName} ${credential.familyName}";
      } else if (userCredential.user?.displayName != null &&
          userCredential.user!.displayName!.isNotEmpty) {
        userName = userCredential.user!.displayName!;
      }

      // Handle potentially null email
      String userEmail = credential.email ?? userCredential.user?.email ?? "";

      UserModel userModel = UserModel(
        email: userEmail,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        phone: "",
        name: userName,
        uId: userCredential.user!.uid,
        brithDate: "",
        gender: "",
        city: "",
        password: '',
        private: false,
        block: false,
        token: '',
      );

      try {
        // Check if user document already exists
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          // Create new user document if it doesn't exist
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(userModel.toMap());
        }

        // Save user data to local storage
        UserDataFromStorage.setUid(userCredential.user!.uid);
        UserDataFromStorage.setUserName(userName);
        UserDataFromStorage.setEmail(userEmail);
        UserDataFromStorage.setPhoneNumber('');
        UserDataFromStorage.setGender('');
        UserDataFromStorage.setBrithDate('');
        UserDataFromStorage.setUserIsGuest(false);

        emit(SignInWithSocialMediaSuccessState());
      } on FirebaseException catch (e) {
        emit(SignInWithSocialMediaErrorState(message: e.toString()));
        throw FireStoreException(firebaseException: e);
      }
    } catch (e) {
      emit(SignInWithSocialMediaErrorState(message: e.toString()));
      debugPrint("Error signing in with Apple: $e");
    }
  }

  bool rememberMe = false;

  void rememberMeFunction(
      {value,
      required String emailController,
      required String passController}) {
    emit(RememberMeLoadingState());
    if (value != null) {
      rememberMe = value;
      UserDataFromStorage.setRememberMe(value);
      if (UserDataFromStorage.rememberMe == true) {
        UserDataFromStorage.setSavedEmail(emailController);
        UserDataFromStorage.setPassword(passController);
      }
    }
    emit(RememberMeSuccessState());
  }

  List<String> allCity = [];

  Future<void> getAllCity()async{

    emit(GetAllCityLoadingState());
    try{
      var response = await FirebaseFirestore.instance.collection('city').get();
      response.docs.forEach((element) {
        allCity.add(element.data()['name']);
      });

      emit(GetAllCitySuccessState());
    }catch(e){
      debugPrint('error in get all city $e');
      emit(GetAllCityErrorState());
    }

  }

  Future<void> launchWhatsApp({required String phoneNumber, required String message})
  async {
    final Uri whatsappUri = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }

}
