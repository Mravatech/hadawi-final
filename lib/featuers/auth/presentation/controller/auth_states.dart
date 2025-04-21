abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class UserLoginLoadingState extends AuthStates {}

class UserLoginSuccessState extends AuthStates {}

class UserLoginErrorState extends AuthStates {
  String message;

  UserLoginErrorState({required this.message});
}

class UserRegisterLoadingState extends AuthStates {}

class UserRegisterSuccessState extends AuthStates {}

class UserRegisterErrorState extends AuthStates {
  String message;

  UserRegisterErrorState({required this.message});
}

class UserSaveDataLoadingState extends AuthStates {}

class UserSaveDataSuccessState extends AuthStates {}

class UserSaveDataErrorState extends AuthStates {
  String message;

  UserSaveDataErrorState({required this.message});
}

class UserLogoutLoadingState extends AuthStates {}

class UserLogoutSuccessState extends AuthStates {}

class UserLogoutErrorState extends AuthStates {
  String message;

  UserLogoutErrorState({required this.message});
}

class UserGetDataLoadingState extends AuthStates {}

class UserGetDataSuccessState extends AuthStates {}

class UserGetDataErrorState extends AuthStates {
  String message;

  UserGetDataErrorState({required this.message});
}

class LoginWithPhoneLoadingState extends AuthStates {}

class LoginWithPhoneSuccessState extends AuthStates {}

class LoginWithPhoneErrorState extends AuthStates {
  String message;

  LoginWithPhoneErrorState({required this.message});
}

class VerifiyOtpCodeLoadingState extends AuthStates {}

class VerifiyOtpCodeSuccessState extends AuthStates {}

class VerifiyOtpCodeErrorState extends AuthStates {
  String message;

  VerifiyOtpCodeErrorState({required this.message});
}

class SignInWithSocialMediaLoadingState extends AuthStates {}

class SignInWithSocialMediaSuccessState extends AuthStates {}

class SignInWithSocialMediaErrorState extends AuthStates {
  String message;

  SignInWithSocialMediaErrorState({required this.message});
}

class SetBrithDayValueState extends AuthStates {}

class SelectGenderTypeState extends AuthStates {}

class ResendCodeTimerState extends AuthStates {}

class ResendCodeTimerFinishedState extends AuthStates {}

class GetUserDataLoadingState extends AuthStates {}

class GetUserDataSuccessState extends AuthStates {}

class GetUserDataErrorState extends AuthStates {
  String message;

  GetUserDataErrorState({required this.message});
}

class CheckUserLoadingState extends AuthStates {}

class CheckUserSuccessState extends AuthStates {}

class CheckUserErrorState extends AuthStates {
  String message;

  CheckUserErrorState({required this.message});
}

class DeleteUserLoadingState extends AuthStates {}

class DeleteUserSuccessState extends AuthStates {}

class DeleteUserErrorState extends AuthStates {
  String message;

  DeleteUserErrorState({required this.message});
}

class ResetPasswordLoadingState extends AuthStates {}

class ResetPasswordSuccessState extends AuthStates {}

class ResetPasswordErrorState extends AuthStates {
  String message;

  ResetPasswordErrorState({required this.message});
}

class RememberMeEnabled extends AuthStates {
  final String email;
  final String password;

  RememberMeEnabled({required this.email, required this.password});
}

class RememberMeLoadingState extends AuthStates {}
class RememberMeSuccessState extends AuthStates {}

class GetAllCityLoadingState extends AuthStates {}
class GetAllCitySuccessState extends AuthStates {}
class GetAllCityErrorState extends AuthStates {}
