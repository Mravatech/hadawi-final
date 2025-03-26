import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hadawi_app/featuers/auth/data/data_source/auth_data_source.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';

abstract class EditProfileDataSource{

  Future<void> editProfileData({
    required String name,
    required String phone,
    required context
  });

}

class EditProfileDataSourceImplement extends EditProfileDataSource{

  BaseAuthDataSource baseAuthDataSource ;

  EditProfileDataSourceImplement({required this.baseAuthDataSource});

  @override
  Future<void> editProfileData({required String name, required String phone, required context}) async{
    try{
      await FirebaseFirestore.instance.collection('users')
          .doc(UserDataFromStorage.uIdFromStorage)
          .update(
          {
            'name': name,
            'phone': phone
          });
      baseAuthDataSource.getUserData(uId: UserDataFromStorage.uIdFromStorage,context: context);
    }on FirebaseException catch(error){
      throw FireStoreException(firebaseException: error);
    }
  }

}