import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';

import '../../../../utiles/error_handling/exceptions/exceptions.dart';
import '../../../friends/data/models/followers_model.dart';

abstract class VisitorsDataSource {

  Future<void> sendFollowRequest({
    required String userId,
    required String followerId,
    required String userName,
    required String image,
  });


}

class VisitorsDataSourceImplement implements VisitorsDataSource {

  @override
  Future<void> sendFollowRequest({
    required String userId,
    required String followerId,
    required String userName,
    required String image,
  }) async{

    FollowersModel followersModel = FollowersModel(
      userId: userId,
      userName: userName,
      image: image,
      follow: false,
    );

    FollowersModel toFollowing = FollowersModel(
      userId: followerId,
      userName: UserDataFromStorage.userNameFromStorage,
      image: image,
      follow: false,
    );

    try{
      await FirebaseFirestore.instance.collection('users')
          .doc(followerId).collection('followers').doc(userId)
          .set(followersModel.toMap());

      await FirebaseFirestore.instance.collection('users')
          .doc(userId).collection('following').doc(followerId)
          .set(toFollowing.toMap());
    }on FirebaseException catch(e){
      throw FireStoreException(firebaseException: e);
    }on Exception catch(e){
      throw Exception(e.toString());
    }


  }


}
