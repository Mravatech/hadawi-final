abstract class EditProfileStates{}

class EditProfileInitialState extends EditProfileStates{}

class EditProfileLoadingState extends EditProfileStates{}
class EditProfileSuccessState extends EditProfileStates{}
class EditProfileErrorState extends EditProfileStates{
  String message;
  EditProfileErrorState({required this.message});
}