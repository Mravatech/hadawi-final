
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/data/models/user_model.dart';
import 'package:hadawi_app/featuers/auth/domain/entities/user_entities.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

abstract class AuthBaseRepository {

  Future<Either<Faliure,void>> login({required String email, required String password,required context});
  Future<Either<Faliure,void>> register({
    required String email,
    required String password,
    required String phone,
    required String name,
    required String city,
    required context,
    required String brithDate,
    required String gender
  });
  Future<Either<Faliure,void>>sendOtp({required String phone,required int otp,});

  Future<Either<Faliure,void>> saveUserData({
    required String email, required String phone,
    required String password,
    required String name, required String uId,required String brithDate,required String gender, required String city});
  Future<Either<Faliure,void>> logout();
  Future<Either<Faliure,void>> loginWithPhoneNumber({
    required String phone,
    required String email,
    required String name,
    required String brithDate,
    required String gender,
    required bool isLogin,
    required bool resendCode,
    required String city,
    required BuildContext context
  });
  Future<Either<Faliure,void>> verifiyPhoneNumber({
        required String email,
        required String phone,
        required String name,
        required String brithDate,
        required bool isLogin,
        required String verificationId,
        required String verifyOtpPinPut,
        required String gender,
        required String city
  });
  Future<Either<Faliure,void>> loginWithGoogle({
    required String brithDate,
    required String gender,
    required context,
    required String city
  });

  Future<Either<Faliure,bool>> checkUserLogin({
    required String phoneNumber,
  });

  Future<Either<Faliure,UserEntities>> getUserInfo({
    required String uId,
    required context
  });

  Future<Either<Faliure, bool>>deleteUser ({required String uId});

}