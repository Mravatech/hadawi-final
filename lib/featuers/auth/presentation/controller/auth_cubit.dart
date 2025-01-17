import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/domain/entities/user_entities.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/get_user_data_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/google_auth_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/login_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/logout.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/register_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/save_data_use_cases.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:intl/intl.dart';

class AuthCubit extends Cubit<AuthStates> {

  AuthCubit(
      this.loginUseCases,
      this.registerUseCases,
      this.saveDataUseCases,
      this.getUserDataUseCases,
      this.logoutUseCases,
      this.googleAuthUseCases,
      ) : super(AuthInitialState());

  LoginUseCases loginUseCases;
  RegisterUseCases registerUseCases;
  SaveDataUseCases saveDataUseCases;
  GetUserDataUseCases getUserDataUseCases;
  LogoutUseCases logoutUseCases;
  GoogleAuthUseCases googleAuthUseCases;

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
  })async {
    emit(UserRegisterLoadingState());
    final result = await registerUseCases.register(
        email: email,
        password: password,
        brithDate: brithDate,
        gender: gender,
        name: name,
        phone: phone
    );
    result.fold((l) {
      emit(UserRegisterErrorState(message: l.message));
    }, (r) {
      customToast(title: 'تم التسجيل', color: ColorManager.primaryBlue);
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
  })async {
    emit(UserSaveDataLoadingState());
    final result = await saveDataUseCases.saveUserData(
        uId: uId,
        email: email,
        phone: phone,
        name: name,
        brithDate: brithDate,
        gender: gender,
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

  UserEntities ?userEntities ;
  Future<void> getUserData({
    required String uId,
})async {
    emit(UserGetDataLoadingState());
    final result = await getUserDataUseCases.getUserData(uId: uId);
    result.fold((l) {
      emit(UserGetDataErrorState(message: l.message));
    }, (r) {
      emit(UserGetDataSuccessState());
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
  })async {
    emit(SignInWithSocialMediaLoadingState());
    final result = await googleAuthUseCases.loginWithGoogle(
        brithDate: brithDate,
        gender: gender,
    );
    result.fold((l) {
      emit(SignInWithSocialMediaErrorState(message: l.message));
    }, (r) {
      customToast(title: 'تم التسجيل', color: ColorManager.primaryBlue);
      emit(SignInWithSocialMediaSuccessState());
    });
  }

  String genderValue='Male';

  void changeGenderValue(String ?value){
    genderValue= value!;
    print(genderValue);
    emit(SelectGenderTypeState());
  }




}