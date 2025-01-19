
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/data/models/user_model.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

abstract class AuthBaseRepository {

  Future<Either<Faliure,void>> login({required String email, required String password});
  Future<Either<Faliure,void>> register({
    required String email,
    required String password,
    required String phone,
    required String name,
    required String brithDate,
    required String gender
  });
  Future<Either<Faliure,void>> saveUserData({required String email, required String phone, required String name, required String uId,required String brithDate,required String gender});
  Future<Either<Faliure,UserModel>> getUserData({required String uId,});
  Future<Either<Faliure,void>> logout();
  Future<Either<Faliure,void>> loginWithPhoneNumber({
    required String phone,
    required String email,
    required String name,
    required String brithDate,
    required String gender,
    required bool resendCode,
    required BuildContext context
  });
  Future<Either<Faliure,void>> verifiyPhoneNumber({
        required String email,
        required String phone,
        required String name,
        required String brithDate,
        required String verificationId,
        required String verifyOtpPinPut,
        required String gender
  });
  Future<Either<Faliure,void>> loginWithGoogle({
    required String brithDate,
    required String gender
  });
}