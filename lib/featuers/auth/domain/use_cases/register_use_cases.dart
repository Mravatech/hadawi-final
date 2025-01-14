
import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class RegisterUseCases{

  AuthBaseRepository authBaseRepository;

  RegisterUseCases({required this.authBaseRepository});

  Future<Either<Faliure,void>> register({
    required String email,
    required String password})async {
    return await authBaseRepository.register(email:email, password:password,);
  }

}