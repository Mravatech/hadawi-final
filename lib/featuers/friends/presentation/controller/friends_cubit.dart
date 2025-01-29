import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/friends/domain/entities/follower_entities.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/accept_follow_request_use_cases.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/get_followers_use_cases.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/get_following_use_cases.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/reject_follow_request_use_cases.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/send_follow_request_use_cases.dart';
import 'package:hadawi_app/featuers/friends/presentation/controller/firends_states.dart';

class FriendsCubit extends Cubit<FriendsStates> {
  FriendsCubit(
    this.sendFollowRequestUseCases,
    this.acceptFollowRequestUseCases,
    this.rejectFollowRequestUseCases,
    this.getFollowingUseCases,
    this.getFollowersUseCases
) : super(FriendsInitialState());
  SendFollowRequestUseCases sendFollowRequestUseCases;
  AcceptFollowRequestUseCases acceptFollowRequestUseCases;
  RejectFollowRequestUseCases rejectFollowRequestUseCases;
  GetFollowingUseCases getFollowingUseCases;
  GetFollowersUseCases getFollowersUseCases;

  Future<void> sendFollowRequest(
      {
        required String userId,
        required String followerId,
        required String userName,
        required String image
      })async{
    emit(SendFollowRequestLoadingState());
    var response = await sendFollowRequestUseCases.call(
         userId: userId,
         followerId: followerId,
         userName: userName,
         image: image
     );

     response.fold(
         (l)=>emit(SendFollowRequestErrorState(message: l.message)),
         (r)=>emit(SendFollowRequestSuccessState())
     );
  }


  Future<void> acceptFollowRequest(
      {
        required String userId,
        required String followerId,

      })async{
    emit(AcceptFollowRequestLoadingState());
    var response = await acceptFollowRequestUseCases.call(
        userId: userId,
        followerId: followerId,
    );

    response.fold(
            (l){
              emit(AcceptFollowRequestErrorState(message: l.message));
            },
            (r)=>emit(AcceptFollowRequestSuccessState())
    );

  }

  Future<void> rejectFollowRequest(
      {
        required String userId,
        required String followerId,

      })async{
    emit(RejectFollowRequestLoadingState());
    var response = await rejectFollowRequestUseCases.call(
      userId: userId,
      followerId: followerId,
    );

    response.fold(
            (l)=>emit(RejectFollowRequestErrorState(message: l.message)),
            (r)=>emit(RejectFollowRequestSuccessState())
    );

  }

  List<FollowerEntities> followers = [];
  List<FollowerEntities> followersRequest = [];
  Future<void> getFollowers(
      {
        required String userId,
      })async{
    followers = [];
    followersRequest = [];
    emit(GetFollowersLoadingState());
    var response = await getFollowersUseCases.call(
      userId: userId,
    );
    response.fold(
            (l)=>emit(GetFollowersErrorState(message: l.message)),
            (r){
              for(var element in r) {
                if (element.follow == false){
                  followersRequest.add(element);
                }else{
                  followers.add(element);
                }
              }
             emit(GetFollowersSuccessState());
            });
  }

  List<FollowerEntities> following = [];
  Future<void> getFollowing(
      {
        required String userId,
      })async{
    following=[];
    emit(GetFollowingLoadingState());
    var response = await getFollowersUseCases.call(
      userId: userId,
    );
    response.fold(
            (l)=>emit(GetFollowingErrorState(message: l.message)),
            (r){
            for(var element in r) {
              if (element.follow == true){
                following.add(element);
              }
            }
          emit(GetFollowingSuccessState());
        });
  }


}