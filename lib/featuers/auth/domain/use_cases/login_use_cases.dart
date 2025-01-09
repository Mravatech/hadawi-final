
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';

class LoginUseCases{

  AuthBaseRepository authBaseRepository;

  LoginUseCases({required this.authBaseRepository});

  Future<void> login({required String email,required String password})async{
    await authBaseRepository.login(
      email:email,
      password:password,
    );
  }

}