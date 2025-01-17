abstract class AuthStates{}

class AuthInitialState extends AuthStates{}

class UserLoginLoadingState extends AuthStates{}
class UserLoginSuccessState extends AuthStates{}
class UserLoginErrorState extends AuthStates{
  String message;
  UserLoginErrorState({required this.message});
}

class UserRegisterLoadingState extends AuthStates{}
class UserRegisterSuccessState extends AuthStates{}
class UserRegisterErrorState extends AuthStates{
  String message;
  UserRegisterErrorState({required this.message});
}

class UserSaveDataLoadingState extends AuthStates{}
class UserSaveDataSuccessState extends AuthStates{}
class UserSaveDataErrorState extends AuthStates{
  String message;
  UserSaveDataErrorState({required this.message});
}

class UserLogoutLoadingState extends AuthStates{}
class UserLogoutSuccessState extends AuthStates{}
class UserLogoutErrorState extends AuthStates{
  String message;
  UserLogoutErrorState({required this.message});
}

class UserGetDataLoadingState extends AuthStates{}
class UserGetDataSuccessState extends AuthStates{}
class UserGetDataErrorState extends AuthStates{
  String message;
  UserGetDataErrorState({required this.message});
}

class SignInWithSocialMediaLoadingState extends AuthStates{}
class SignInWithSocialMediaSuccessState extends AuthStates{}
class SignInWithSocialMediaErrorState extends AuthStates{
  String message;
  SignInWithSocialMediaErrorState({required this.message});
}

class SetBrithDayValueState extends AuthStates{}

class SelectGenderTypeState extends AuthStates{}
