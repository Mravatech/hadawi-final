import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/edit_personal_info/domain/use_cases/edit_profile_use_cases.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/controller/edit_profile_states.dart';

class EditProfileCubit extends Cubit<EditProfileStates>{

  EditProfileCubit({required this.editProfileUseCases}):super(EditProfileInitialState());

  EditProfileUseCases editProfileUseCases;


  Future<void> editProfile({required String name, required String phone,required context,required String gender})async{
    emit(EditProfileLoadingState());
    var result = await editProfileUseCases.editProfile(name: name, phone: phone,context: context,gender: gender);
    result.fold((l) {
      emit(EditProfileErrorState(message: l.message));
    }, (r) {
      emit(EditProfileSuccessState());
    });

  }






}