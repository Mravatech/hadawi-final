
import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class RegisterUseCases{

  AuthBaseRepository authBaseRepository;

  RegisterUseCases({required this.authBaseRepository});

  Future<Either<Faliure,void>> register({
    required String email,
    required String password,
    required String phone,
    required String name,
    required String brithDate,
    required String gender
  })async {
    return await authBaseRepository.register(
        email: email,
        password: password,
        brithDate: brithDate,
        gender: gender,
        name: name,
        phone: phone
    );
  }

}