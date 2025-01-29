abstract class FriendsStates{}

class FriendsInitialState extends FriendsStates{}

class SendFollowRequestLoadingState extends FriendsStates{}
class SendFollowRequestSuccessState extends FriendsStates{}
class SendFollowRequestErrorState extends FriendsStates{
  String message;
  SendFollowRequestErrorState({required this.message});
}

class AcceptFollowRequestLoadingState extends FriendsStates{}
class AcceptFollowRequestSuccessState extends FriendsStates{}
class AcceptFollowRequestErrorState extends FriendsStates{
  String message;
  AcceptFollowRequestErrorState({required this.message});
}

class RejectFollowRequestLoadingState extends FriendsStates{}
class RejectFollowRequestSuccessState extends FriendsStates{}
class RejectFollowRequestErrorState extends FriendsStates{
  String message;
  RejectFollowRequestErrorState({required this.message});
}

class GetFollowingLoadingState extends FriendsStates{}
class GetFollowingSuccessState extends FriendsStates{}
class GetFollowingErrorState extends FriendsStates{
  String message;
  GetFollowingErrorState({required this.message});
}

class GetFollowersLoadingState extends FriendsStates{}
class GetFollowersSuccessState extends FriendsStates{}
class GetFollowersErrorState extends FriendsStates{
  String message;
  GetFollowersErrorState({required this.message});
}