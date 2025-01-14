import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hadawi_app/featuers/auth/data/models/user_model.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';

abstract class BaseAuthDataSource {

  Future<void> login({required String email, required String password});
  Future<void> register({required String email, required String password});
  Future<void> saveUserData({required String email, required String phone, required String name, required String uId,required String brithDate,required String gender});
  Future<UserModel> getUserData({required String uId,});
  Future<void> logout();

}

class AuthDataSourceImplement extends BaseAuthDataSource {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> login({required String email, required String password}) async{

    try{
      firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e){
      throw FirebaseExceptions(firebaseAuthException: e);
    }

  }

  @override
  Future<void> logout() async{
    try{
      await firebaseAuth.signOut();
    }on FirebaseAuthException catch(e){
      throw FirebaseExceptions(firebaseAuthException: e);
    }
  }

  @override
  Future<void> register({required String email, required String password})async {
     try{
       await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
     }on FirebaseAuthException catch(e){
       throw FirebaseExceptions(firebaseAuthException: e);
     }
    
  }

  @override
  Future<void> saveUserData({
    required String email,
    required String phone,
    required String name,
    required String uId,
    required String brithDate,
    required String gender
  }) async {
     UserModel userModel = UserModel(
         email: email,
         phone: phone,
         name: name,
         uId: uId,
         brithDate: brithDate,
         gender: gender
     );

    try{
      await firestore.collection('users').doc(uId).set(userModel.toMap());
    }on FireStoreException catch(e){
      throw FireStoreException(firebaseException: e.firebaseException);
    }
  }

  @override
  Future<UserModel> getUserData({required String uId})async {
    try{
      final user = await firestore.collection('users').doc(uId).get();
      return UserModel.fromFire(user.data()!);
    }on FireStoreException catch(e){
      throw FireStoreException(firebaseException: e.firebaseException);
    }
  }
}