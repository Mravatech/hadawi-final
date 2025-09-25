import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hadawi_app/featuers/auth/data/data_source/auth_data_source.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';

abstract class EditProfileDataSource {
  Future<void> editProfileData(
      {String? name,
      String? phone,
      String? gender,
      String? birthDate,
      String? email,
      context});
}

class EditProfileDataSourceImplement extends EditProfileDataSource {
  BaseAuthDataSource baseAuthDataSource;

  EditProfileDataSourceImplement({required this.baseAuthDataSource});

  @override
  Future<void> editProfileData(
      {
       String? name,
       String? birthDate,
       String? phone,
       context,
       String? gender,
       String? email}) async {
    try {
      // Prepare update data
      Map<String, dynamic> updateData = {
        'name': name,
        'phone': phone,
        'gender': gender,
        'brithDate': birthDate
      };
      
      // Add email to update data if provided
      if (email != null && email.isNotEmpty) {
        updateData['email'] = email;
        // Update shared preferences with new email
        UserDataFromStorage.setEmail(email);
      }
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(UserDataFromStorage.uIdFromStorage)
          .update(updateData);
      baseAuthDataSource.getUserData(
          uId: UserDataFromStorage.uIdFromStorage, context: context);
    } on FirebaseException catch (error) {
      throw FireStoreException(firebaseException: error);
    }
  }
}
