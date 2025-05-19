abstract class EditProfileStates{}

class EditProfileInitialState extends EditProfileStates{}

class SetBrithDayState extends EditProfileStates{}
class SelectGenderState extends EditProfileStates{}
class EditProfileLoadingState extends EditProfileStates{}
class EditProfileSuccessState extends EditProfileStates{}
class EditProfileErrorState extends EditProfileStates{
  String message;
  EditProfileErrorState({required this.message});
}

class CheckPhoneLoadingState extends EditProfileStates{}
class CheckPhoneSuccessState extends EditProfileStates{}
class CheckPhoneErrorState extends EditProfileStates{}