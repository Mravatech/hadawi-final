import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/friends/domain/repo/friends_repo.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class SendFollowRequestUseCases {

  FriendsRepo friendsRepo;

  SendFollowRequestUseCases({
    required this.friendsRepo,
  });

  Future<Either<Faliure, void>> call({
    required String userId,
    required String followerId,
    required String userName,
    required String image,
  })async {
    return await friendsRepo.sendFollowRequest(
      userId: userId,
      followerId: followerId,
      userName: userName,
      image: image,
    );
  }


}