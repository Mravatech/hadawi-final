import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/friends/domain/repo/friends_repo.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class RejectFollowRequestUseCases {

  FriendsRepo friendsRepo;

  RejectFollowRequestUseCases({
    required this.friendsRepo,
  });

  Future<Either<Faliure, void>> call({
    required String userId,
    required String followerId,
  })async {
    return await friendsRepo.rejectFollowRequest(
      userId: userId,
      followerId: followerId,
    );
  }


}