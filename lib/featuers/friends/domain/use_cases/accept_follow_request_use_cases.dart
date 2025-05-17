import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/friends/domain/repo/friends_repo.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class AcceptFollowRequestUseCases {

  FriendsRepo friendsRepo;

  AcceptFollowRequestUseCases({
    required this.friendsRepo,
  });

  Future<Either<Faliure, void>> call({
    required String userId,
    required String followerId,
    required String userName,
  })async {
    return await friendsRepo.acceptFollowRequest(
      userId: userId,
      followerId: followerId,
      userName: userName,

    );
  }


}