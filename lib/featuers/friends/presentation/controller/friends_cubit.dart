import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/friends/domain/entities/follower_entities.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/accept_follow_request_use_cases.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/get_followers_use_cases.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/get_following_use_cases.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/reject_follow_request_use_cases.dart';
import 'package:hadawi_app/featuers/friends/presentation/controller/firends_states.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';

class FriendsCubit extends Cubit<FriendsStates> {
  FriendsCubit(
      this.acceptFollowRequestUseCases,
      this.rejectFollowRequestUseCases,
      this.getFollowingUseCases,
      this.getFollowersUseCases
      ) : super(FriendsInitialState());
  AcceptFollowRequestUseCases acceptFollowRequestUseCases;
  RejectFollowRequestUseCases rejectFollowRequestUseCases;
  GetFollowingUseCases getFollowingUseCases;
  GetFollowersUseCases getFollowersUseCases;




  Future<void> acceptFollowRequest(
      {
        required String userId,
        required String followerId,
        required String userName,
      })async{
    emit(AcceptFollowRequestLoadingState());
    var response = await acceptFollowRequestUseCases.call(
        userId: userId,
        followerId: followerId,
        userName: userName
    );

    response.fold(
            (l){
          emit(AcceptFollowRequestErrorState(message: l.message));
        },
            (r){
          getFollowing(userId: UserDataFromStorage.uIdFromStorage);
          emit(AcceptFollowRequestSuccessState());
        }
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
            (r){
          getFollowing(userId: UserDataFromStorage.uIdFromStorage);
          emit(RejectFollowRequestSuccessState());
        }
    );

  }

  List<FollowerEntities> followers = [];
  List<FollowerEntities> followersRequest = [];
  Future<void> getFollowers(
      {
        required String userId,
      })async{
    followers = [];
    emit(GetFollowersLoadingState());
    var response = await getFollowersUseCases.call(
      userId: userId,
    );
    response.fold(
            (l)=>emit(GetFollowersErrorState(message: l.message)),
            (r){
          for(var element in r) {
            if (element.follow == false){
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
    followersRequest=[];
    emit(GetFollowingLoadingState());
    var response = await getFollowingUseCases.call(
      userId: userId,
    );
    response.fold(
            (l)=>emit(GetFollowingErrorState(message: l.message)),
            (r){
          for(var element in r) {
            print('Elemnet flow ${element.follow}');
            if (element.follow == true){
              following.add(element);
            }else{
              followersRequest.add(element);
            }
          }
          emit(GetFollowingSuccessState());
        });
  }


}