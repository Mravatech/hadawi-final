import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/friends/data/data_source/friends_data_source.dart';
import 'package:hadawi_app/featuers/friends/data/models/followers_model.dart';
import 'package:hadawi_app/featuers/friends/domain/repo/friends_repo.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class FriendsRepoImplement extends FriendsRepo {

  FriendsDataSource friendsDataSource;

  FriendsRepoImplement({required this.friendsDataSource});

  @override
  Future<Either<Faliure, void>> acceptFollowRequest({
    required String userId,
    required String followerId
  })async {

    try{
      return Right(await friendsDataSource.acceptFollowRequest(userId: userId, followerId: followerId));
    }on FireStoreException catch(e){
      return Left(FireStoreFaliure.fromMessage(e));
    }on Exception catch(e){
      return Left(Faliure(message: e.toString()));
    }

  }

  @override
  Future<Either<Faliure, List<FollowersModel>>> getMyFollowers({
    required String userId
  }) async{
    try{
      return Right(await friendsDataSource.getMyFollowers(userId: userId,));
    }on FireStoreException catch(e){
      return Left(FireStoreFaliure.fromMessage(e));
    }on Exception catch(e){
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, List<FollowersModel>>> getMyFollowing({
    required String userId
  }) async{
    try{
      return Right(await friendsDataSource.getMyFollowing(userId: userId,));
    }on FireStoreException catch(e){
      return Left(FireStoreFaliure.fromMessage(e));
    }on Exception catch(e){
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, void>> rejectFollowRequest({
    required String userId,
    required String followerId
  }) async{
    try{
      return Right(await friendsDataSource.rejectFollowRequest(userId: userId, followerId: followerId));
    }on FireStoreException catch(e){
    return Left(FireStoreFaliure.fromMessage(e));
    }on Exception catch(e){
    return Left(Faliure(message: e.toString()));
    }
  }


}