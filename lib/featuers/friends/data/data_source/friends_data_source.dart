import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hadawi_app/featuers/auth/data/models/user_model.dart';
import 'package:hadawi_app/featuers/friends/data/models/followers_model.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';

abstract class FriendsDataSource {
  
  Future<List<FollowersModel>> getMyFollowers({
    required String userId,
  });
  Future<List<FollowersModel>> getMyFollowing({
    required String userId,
  });

  Future<void> acceptFollowRequest({
    required String userId,
    required String followerId,
  });
  Future<void> rejectFollowRequest({
    required String userId,
    required String followerId,
  });
  
}

class FriendsDataSourceImplement implements FriendsDataSource {
  
  @override
  Future<void> acceptFollowRequest({
    required String userId,
    required String followerId,
  })async {

    try{
      await FirebaseFirestore.instance.collection('users')
          .doc(followerId).collection('following').doc(userId)
          .update({'follow': true,}).then((value) {
      });

      await FirebaseFirestore.instance.collection('users')
          .doc(userId).collection('followers').doc(followerId)
          .update({'follow': true,}).then((value) {
      });

     await getMyFollowers(userId: followerId);
     await getMyFollowing(userId: followerId);

    }on FirebaseException catch(e){
      throw FireStoreException(firebaseException: e);
    }on Exception catch(e){
      throw Exception(e.toString());
    }

  }

  @override
  Future<List<FollowersModel>> getMyFollowers({
    required String userId,
  }) async{
    List<FollowersModel> followers = [];
    try{
     var response =  await FirebaseFirestore.instance.collection('users')
          .doc(userId).collection('followers').get();

      for (var element in response.docs) {
        followers.add(FollowersModel.fromJson(element.data()));
      }
      return followers;
    }on FirebaseException catch(e){
      throw FireStoreException(firebaseException: e);
    }on Exception catch(e){
      throw Exception(e.toString());
    }

  }

  @override
  Future<List<FollowersModel>> getMyFollowing({
    required String userId,
  }) async{
    List<FollowersModel> following = [];
    try{
      var response =  await FirebaseFirestore.instance.collection('users')
          .doc(userId).collection('following').get();

      for (var element in response.docs) {
        following.add(FollowersModel.fromJson(element.data()));
      }
      return following;
    }on FirebaseException catch(e){
      throw FireStoreException(firebaseException: e);
    }on Exception catch(e){
      throw Exception(e.toString());
    }

  }

  @override
  Future<void> rejectFollowRequest({
    required String userId,
    required String followerId,
  }) async{
    try{

      await FirebaseFirestore.instance.collection('users')
          .doc(followerId).collection('following').doc(userId)
          .update({'follow': true,});

      await FirebaseFirestore.instance.collection('users')
          .doc(userId).collection('followers').doc(followerId)
          .update({'follow': true,});

      await getMyFollowers(userId: followerId);
      await getMyFollowing(userId: followerId);

    }on FirebaseException catch(e){
      throw FireStoreException(firebaseException: e);
    }on Exception catch(e){
      throw Exception(e.toString());
    }
  }


  
  
}