
import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class LoginUseCases{

  AuthBaseRepository authBaseRepository;

  LoginUseCases({required this.authBaseRepository});

  Future<Either<Faliure,void>> login({
    required String email,
    required context,
    required String password,
    bool isMobileLogin = false})async {
    return await authBaseRepository.login(email:email, password:password,context: context, isMobileLogin: isMobileLogin);
  }

}