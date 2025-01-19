import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/data/data_source/auth_data_source.dart';
import 'package:hadawi_app/featuers/auth/data/models/user_model.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

 class AuthRepositoryImplement extends AuthBaseRepository {

  BaseAuthDataSource baseAuthDataSource;

  AuthRepositoryImplement({required this.baseAuthDataSource});

  @override
  Future<Either<Faliure,void>> login({required String email, required String password}) async{
    try{
      return Right(await baseAuthDataSource.login(email: email, password: password));
    }on FirebaseExceptions catch(e){
      return Left(FirebaseFaliure.fromMessage(e));
    }
  }


  @override
  Future<Either<Faliure,void>> register({
    required String email,
    required String password,
    required String phone,
    required String name,
    required String brithDate,
    required String gender
  })async {
    try{
      return Right(await baseAuthDataSource.register(
          email: email,
          password: password,
          brithDate: brithDate,
          gender: gender,
          name: name,
          phone: phone
      ));
    }on FirebaseExceptions catch(e){
    return Left(FirebaseFaliure.fromMessage(e));
    }catch (e) {
      print('error in register $e');
      return Left(FirebaseFaliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, UserModel>> getUserData({required String uId}) async{
    try{
      return Right(await baseAuthDataSource.getUserData(uId: uId));
    }on FireStoreException catch(e){
    return Left(FirebaseFaliure(message: e.firebaseException.message!));
    }
  }

  @override
  Future<Either<Faliure, void>> logout()async {
    try{
      return Right(await baseAuthDataSource.logout());
    }on FirebaseExceptions catch(e){
      return Left(FirebaseFaliure.fromMessage(e));
    }
  }

  @override
  Future<Either<Faliure, void>> saveUserData({
    required String email,
    required String phone,
    required String name,
    required String uId,
    required String brithDate,
    required String gender
  })async {
    try{
      return Right(await baseAuthDataSource.saveUserData(
          email: email,
          phone: phone,
          name: name,
          uId: uId,
          brithDate: brithDate,
          gender: gender
          ));
    }on FireStoreException catch(e){
    return Left(FirebaseFaliure(message: e.firebaseException.message!));
    }
  }

  @override
  Future<Either<Faliure, void>> loginWithGoogle(
      {
        required String brithDate,
        required String gender
      }) async{
    try{
      return Right(await baseAuthDataSource.loginWithGoogle(
          brithDate: brithDate,
          gender: gender
      )
      );
    }on FirebaseExceptions catch(e){
      return Left(GoogleAuthFaliure.fromMessage(e));
    }


  }

  @override
  Future<Either<Faliure, void>> loginWithPhoneNumber({
    required String phone,
    required BuildContext context,
    required String email,
    required String name,
    required bool resendCode,
    required String brithDate,
    required String gender,
  }) async{
    try{
       return Right(await baseAuthDataSource.loginWithPhoneNumber(
           email: email,
           name: name,
           brithDate: brithDate,
           gender: gender,
           phone: phone,
           resendCode: resendCode,
           context: context
       ));
    }on FirebaseExceptions catch(e){
       return Left(FirebaseFaliure.fromMessage(e));
    }on Exception catch(e){
      return Left(FirebaseFaliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, void>> verifiyPhoneNumber({
    required String email,
    required String phone,
    required String name,
    required String brithDate,
    required String verificationId,
    required String verifyOtpPinPut,
    required String gender
  })async {
    try{
      return Right(await baseAuthDataSource.verifiyPhoneNumber(
          email: email,
          phone: phone,
          name: name,
          brithDate: brithDate,
          verificationId: verificationId,
          verifyOtpPinPut: verifyOtpPinPut,
          gender: gender
    ));
    }on FirebaseExceptions catch(e){
    return Left(FirebaseFaliure.fromMessage(e));
    }
  }

}