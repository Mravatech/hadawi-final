import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class VerifiyCodeUseCases{

  AuthBaseRepository authBaseRepository;

  VerifiyCodeUseCases({required this.authBaseRepository});

  Future<Either<Faliure,void>> call({
    required String email,
    required String phone,
    required String name,
    required String brithDate,
    required String verificationId,
    required String verifyOtpPinPut,
    required bool isLogin,
    required String gender
})async{
      return await authBaseRepository.verifiyPhoneNumber(
          email: email,
          phone: phone,
          name: name,
          brithDate: brithDate,
          isLogin: isLogin,
          verificationId: verificationId,
          verifyOtpPinPut: verifyOtpPinPut,
          gender: gender
      );
  }



}