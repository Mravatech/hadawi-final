import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class LoginWithPhoneUseCases{

  AuthBaseRepository authBaseRepository;

  LoginWithPhoneUseCases({required this.authBaseRepository});

  Future<Either<Faliure,void>> call({
    required String phone,
    required String email,
    required String name,
    required String brithDate,
    required String gender,
    required bool resendCode,
    required bool isLogin,
    required BuildContext context
  })async{
      return await authBaseRepository.loginWithPhoneNumber(
          phone: phone,
          email: email,
          name: name,
          brithDate: brithDate,
          resendCode: resendCode,
          isLogin: isLogin,
          gender: gender,
          context: context
      );
  }



}