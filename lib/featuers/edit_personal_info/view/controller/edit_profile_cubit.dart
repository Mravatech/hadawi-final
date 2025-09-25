import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/edit_personal_info/domain/use_cases/edit_profile_use_cases.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/controller/edit_profile_states.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:intl/intl.dart';

class EditProfileCubit extends Cubit<EditProfileStates> {
  EditProfileCubit({required this.editProfileUseCases})
      : super(EditProfileInitialState());

  EditProfileUseCases editProfileUseCases;

  Future<void> editProfile(
      { String? name,
       String? phone,
       String? birthDate,
       context,
       String? gender,
       String? email}) async {
    emit(EditProfileLoadingState());
    var result = await editProfileUseCases.editProfile(
      birthDate: birthDate,
        name: name, phone: phone, context: context, gender: gender, email: email);
    result.fold((l) {
      emit(EditProfileErrorState(message: l.message));
    }, (r) {
      emit(EditProfileSuccessState());
    });
  }

  bool isUsed = false;

  Future<void> getUserInfo({required String phone,required context,required String name,required String gender,required String date, String? email})async{
    isUsed=false;
    emit(CheckPhoneLoadingState());
    
    try {
      // check if phone number is used by other user
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();
      
      // Filter out the current user from results
      final otherUsersWithSamePhone = querySnapshot.docs
          .where((doc) => doc.id != UserDataFromStorage.uIdFromStorage)
          .toList();
      
      debugPrint('Found ${otherUsersWithSamePhone.length} other users with same phone number');

      if(otherUsersWithSamePhone.isEmpty){
        isUsed=false;
        await editProfile(
          name:name,
          context: context,
          gender: gender,
          phone: phone,
          birthDate: date,
          email: email
        );
      }else{
        isUsed=true;
        customToast(title: AppLocalizations.of(context)!.translate('phoneToastError').toString() , color: Colors.red);
      }

      emit(CheckPhoneSuccessState());
    } catch (error) {
      isUsed=false;
      debugPrint("error in getting user info: $error");
      emit(CheckPhoneErrorState());
    }
  }

  void setBrithDate(
      {required DateTime brithDateValue,
      required TextEditingController brithDateController}) {
    brithDateController.text = DateFormat('yyyy-MM-dd').format(brithDateValue);
    emit(SetBrithDayState());
  }

  String genderValue = 'Male';

  void changeGenderValue(String? value) {
    genderValue = value!;
    print(genderValue);
    emit(SelectGenderState());
  }
}
