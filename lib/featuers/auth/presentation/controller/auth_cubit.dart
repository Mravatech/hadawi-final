import 'dart:async';

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
      emit(UserLoginErrorState(message: 'تم حذف الحساب من قبل اداره التطبيق'));
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
      emit(UserRegisterErrorState(message: l.message));
    }, (r) {
      emit(UserRegisterSuccessState());
    });
  }

  Future<void> saveUserData(
      {required String uId,
      required String email,
      required String phone,
      required String name,
      required String brithDate,
      required String gender,
      required String city}) async {
    emit(UserSaveDataLoadingState());
    final result = await saveDataUseCases.saveUserData(
        uId: uId,
        email: email,
        phone: phone,
        name: name,
        brithDate: brithDate,
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

  Future<void> deleteUser({required String uId}) async {
    emit(DeleteUserLoadingState());
    final result = await deleteUserUseCases.deleteUser(uId: uId);
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
      required String city}) async {
    emit(SignInWithSocialMediaLoadingState());
    try {
      final result = await googleAuthUseCases.loginWithGoogle(
          brithDate: brithDate, gender: gender, city: city);
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

      UserModel userModel = UserModel(
          email: userCredential.user!.email.toString(),
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          phone: "",
          name: "${credential.givenName} ${credential.familyName}",
          uId: userCredential.user!.uid.toString(),
          brithDate: "",
          gender: "",
          city: "",
          block: false,
          token: '',
      );

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid.toString())
            .set(userModel.toMap());
        UserDataFromStorage.setUid(userCredential.user!.uid.toString());
        UserDataFromStorage.setUserName(
            "${credential.givenName} ${credential.familyName}");
        UserDataFromStorage.setEmail(credential.email.toString());
        UserDataFromStorage.setPhoneNumber('');
        UserDataFromStorage.setGender('');
        UserDataFromStorage.setBrithDate('');
        UserDataFromStorage.setUserIsGuest(false);
        emit(SignInWithSocialMediaSuccessState());
      } on FireStoreException catch (e) {
        emit(SignInWithSocialMediaErrorState(message: e.toString()));
        throw FireStoreException(firebaseException: e.firebaseException);
      }
    } catch (e) {
      emit(SignInWithSocialMediaErrorState(message: e.toString()));
      debugPrint("خطأ في تسجيل الدخول: $e");
    }
  }

  bool rememberMe = false;

  void rememberMeFunction(
      {value,required String emailController,required String passController}) {
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
}
