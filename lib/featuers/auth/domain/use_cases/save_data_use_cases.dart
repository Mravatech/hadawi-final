
import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class SaveDataUseCases{

  AuthBaseRepository authBaseRepository;

  SaveDataUseCases({required this.authBaseRepository});

  Future<Either<Faliure,void>> saveUserData({
    required String email,
    required String phone,
    required String name,
    required String uId,
    required String brithDate,
    required String gender,
    required String password,
    required String city,
    String firstName = '',
    String lastName = ''
  })async {
    return await authBaseRepository.saveUserData(
        email: email,
        phone: phone,
        name: name,
        password: password,
        uId: uId,
        brithDate: brithDate,
        gender: gender,
        city: city,
        firstName: firstName,
        lastName: lastName
    );
  }

}