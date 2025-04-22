import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/edit_personal_info/domain/repo/edit_profile_repo.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class EditProfileUseCases{

  EditProfileRepo editProfileRepo;

  EditProfileUseCases({required this.editProfileRepo});

  Future<Either<Faliure,void>> editProfile({required String phone,required String gender ,required String name,required context})async{
     return await editProfileRepo.editProfile(phone: phone, userName: name,context: context,gender: gender);
  }

}