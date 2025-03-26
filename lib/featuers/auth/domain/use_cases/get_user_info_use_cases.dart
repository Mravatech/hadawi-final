import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/featuers/auth/domain/entities/user_entities.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class GetUserInfoUseCases{

  AuthBaseRepository authBaseRepository;

  GetUserInfoUseCases({required this.authBaseRepository});

  Future<Either<Faliure,UserEntities>> getUserInfo({required String uId,required context})async{
    return await authBaseRepository.getUserInfo(uId: uId,context: context);
  }

}