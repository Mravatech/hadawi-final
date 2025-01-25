import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class CheckUserLoginUseCases{

  AuthBaseRepository authBaseRepository;

  CheckUserLoginUseCases({required this.authBaseRepository});

  Future<Either<Faliure,bool>> checkUserLogin({required String phoneNumber})async{
    return await authBaseRepository.checkUserLogin(phoneNumber: phoneNumber);
  }

}