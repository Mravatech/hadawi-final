import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class GoogleAuthUseCases{

  AuthBaseRepository authBaseRepository;

  GoogleAuthUseCases({required this.authBaseRepository});

  Future<Either<Faliure, void>> loginWithGoogle({
    required String brithDate,
    required String gender
  })async {
    return await authBaseRepository.loginWithGoogle(
        brithDate: brithDate,
        gender: gender
    );
  }

}