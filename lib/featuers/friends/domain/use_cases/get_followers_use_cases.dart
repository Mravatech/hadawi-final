import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/friends/domain/entities/follower_entities.dart';
import 'package:hadawi_app/featuers/friends/domain/repo/friends_repo.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class GetFollowersUseCases {

  FriendsRepo friendsRepo;

  GetFollowersUseCases({
    required this.friendsRepo,
  });

  Future<Either<Faliure, List<FollowerEntities>>> call({
    required String userId,
  })async {
    return await friendsRepo.getMyFollowers(
      userId: userId,
    );
  }


}