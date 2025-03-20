import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:intl/intl.dart';

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

  TextEditingController brithDateController = TextEditingController();

  Future<void> login({required String email, required String password})async {
    emit(UserLoginLoadingState());
    final result = await loginUseCases.login(email: email, password: password);
    result.fold((l) {
      emit(UserLoginErrorState(message: l.message));
    }, (r) {
      emit(UserLoginSuccessState());
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String phone,
    required String name,
    required String brithDate,
    required String gender,
    required String city,
  })async {
    emit(UserRegisterLoadingState());
    final result = await registerUseCases.register(
        email: email,
        password: password,
        brithDate: brithDate,
        gender: gender,
        name: name,
        phone: phone,
        city: city
    );
    result.fold((l) {
      emit(UserRegisterErrorState(message: l.message));
    }, (r) {
      emit(UserRegisterSuccessState());
    });
  }

  Future<void> saveUserData({
    required String uId,
    required String email,
    required String phone,
    required String name,
    required String brithDate,
    required String gender,
    required String city
  })async {
    emit(UserSaveDataLoadingState());
    final result = await saveDataUseCases.saveUserData(
        uId: uId,
        email: email,
        phone: phone,
        name: name,
        brithDate: brithDate,
        gender: gender,
        city: city
    );
    result.fold((l) {
      emit(UserSaveDataErrorState(message: l.message));
    }, (r) {
      emit(UserSaveDataSuccessState());
    });
  }

  Future<void> logout()async {
    emit(UserLogoutLoadingState());
    final result = await logoutUseCases.logout();
    result.fold((l) {
      emit(UserLogoutErrorState(message: l.message));
    }, (r) {
      emit(UserLogoutSuccessState());
    });
  }

  Future<void> deleteUser({required String uId})async {
    emit(DeleteUserLoadingState());
    final result = await deleteUserUseCases.deleteUser(uId: uId);
    result.fold((l) {
      emit(DeleteUserErrorState(message: l.message));
    }, (r) {
      emit(DeleteUserSuccessState());
    });
  }


  void setBrithDate({
    required DateTime brithDateValue
  }){
    brithDateController.text=DateFormat('yyyy-MM-dd').format(brithDateValue);
    emit(SetBrithDayValueState());
  }

  Future<void> signInWithGoogle({
    required String brithDate,
    required String gender,
    required String city
  })async {
    emit(SignInWithSocialMediaLoadingState());
    try{
      final result = await googleAuthUseCases.loginWithGoogle(
        brithDate: brithDate,
        gender: gender,
        city: city
      );
      result.fold((l) {
        emit(SignInWithSocialMediaErrorState(message: l.message));
      }, (r) {
        customToast(title: 'تم التسجيل', color: ColorManager.primaryBlue);
        emit(SignInWithSocialMediaSuccessState());
      });
    }catch (e){
      emit(SignInWithSocialMediaErrorState(message: ''));
    }

  }

  String genderValue='Male';

  void changeGenderValue(String ?value){
    genderValue= value!;
    print(genderValue);
    emit(SelectGenderTypeState());
  }

  bool isLoading = false;

  Future<void> loginWithPhone({
    required String phone,
    required String email,
    required String name,
    required String brithDate,
    required String gender,
    required String city,
    required bool resendCode,
    required bool isLogin,
    required BuildContext context
  })async {
    isLoading = true;
    emit(LoginWithPhoneLoadingState());
    final result = await loginWithPhoneUseCases.call(
      context:  context,
      phone: phone,
      email: email,
      name: name,
      resendCode: resendCode,
      isLogin: isLogin,
      brithDate: brithDate,
      gender: gender,
      city: city
    );
    result.fold((l) {
       isLoading = false;
      emit(LoginWithPhoneErrorState(message: l.message));
    }, (r)async {
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
  })async {
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
          verifyOtpPinPut: verifyOtpPinPut
      );

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


  Future<void> getUserInfo({required String uId})async {
    emit(GetUserDataLoadingState());
    final result = await getUserInfoUseCases.getUserInfo(uId: uId);
    result.fold(
          (l) => emit(GetUserDataErrorState(message: l.message)),
          (r){
            emit(GetUserDataSuccessState());
          }
    );
  }


  Future<void> checkUserLogin({required String phoneNumber})async {
    emit(CheckUserLoadingState());
    final result = await checkUserLoginUseCases
        .checkUserLogin(phoneNumber: phoneNumber);
    result.fold(
            (l) => emit(CheckUserErrorState(message: l.message)),
            (r){
              emit(CheckUserSuccessState());
            }
    );
  }


  Future<void> resetPassword({required String email})async {
    emit(ResetPasswordLoadingState());
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(ResetPasswordSuccessState());
    }catch(e){
      debugPrint("error in reset password: $e");
      emit(ResetPasswordErrorState(message: e.toString()));
    }

  }


}