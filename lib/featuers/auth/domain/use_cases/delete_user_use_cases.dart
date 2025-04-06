
import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class DeleteUserUseCases{

  AuthBaseRepository authBaseRepository;

  DeleteUserUseCases({required this.authBaseRepository});

  Future<Either<Faliure,bool>> deleteUser({
    required String uId,
  })async {
    return await authBaseRepository.deleteUser(uId:uId);
  }

}