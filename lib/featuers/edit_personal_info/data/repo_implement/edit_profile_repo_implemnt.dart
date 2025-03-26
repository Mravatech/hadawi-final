import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/auth/domain/entities/user_entities.dart';
import 'package:hadawi_app/featuers/edit_personal_info/data/data_source/edit_profile_data_source.dart';
import 'package:hadawi_app/featuers/edit_personal_info/domain/repo/edit_profile_repo.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class EditProfileRepoImplement extends EditProfileRepo{

  EditProfileDataSource editProfileDataSource;

  EditProfileRepoImplement({required this.editProfileDataSource});

  @override
  Future<Either<Faliure, void>> editProfile({required String userName, required String phone,required context}) async{
    try{
      return Right(await editProfileDataSource.editProfileData(
          name: userName,
          context: context,
          phone: phone
      ));
    }on FireStoreException catch(e){
      return Left(FireStoreFaliure.fromMessage(e));
    }

  }

}