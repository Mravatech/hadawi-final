import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/friends/data/models/followers_model.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

abstract class FriendsRepo {
  Future<Either<Faliure, List<FollowersModel>>> getMyFollowers({
    required String userId,
  });
  Future<Either<Faliure, List<FollowersModel>>> getMyFollowing({
    required String userId,
  });

  Future<Either<Faliure, void>> acceptFollowRequest({
    required String userId,
    required String followerId,
    required String userName,
  });
  Future<Either<Faliure, void>> rejectFollowRequest({
    required String userId,
    required String followerId,
  });

}