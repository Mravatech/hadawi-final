
import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class GetUserDataUseCases{

  AuthBaseRepository authBaseRepository;

  GetUserDataUseCases({required this.authBaseRepository});

  Future<Either<Faliure,void>> getUserData({
    required String uId,
  })async {
    return await authBaseRepository.getUserData(uId: uId,);
  }
}