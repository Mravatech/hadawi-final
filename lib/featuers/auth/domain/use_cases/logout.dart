
import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class LogoutUseCases{

  AuthBaseRepository authBaseRepository;

  LogoutUseCases({required this.authBaseRepository});

  Future<Either<Faliure,void>> logout()
  async {
    return await authBaseRepository.logout();
  }

}