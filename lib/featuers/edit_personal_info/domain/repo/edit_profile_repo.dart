import 'package:dartz/dartz.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

abstract class EditProfileRepo{

  Future<Either<Faliure,void>> editProfile({
     String? userName,
     String? phone,
     String? gender,
     String? birthDate,
     String? email,
    required context
  });

}