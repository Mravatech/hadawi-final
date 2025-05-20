part of 'visitors_cubit.dart';

@immutable
sealed class VisitorsState {}

final class VisitorsInitial extends VisitorsState {}
final class GetOccasionsLoadingState extends VisitorsState {}
final class GetOccasionsStillLoadingState extends VisitorsState {}
final class GetOccasionsSuccessState extends VisitorsState {
  final List<OccasionEntity> activeOccasions;
  final List<CompleteOccasionModel> doneOccasions;
  GetOccasionsSuccessState({required this.activeOccasions, required this.doneOccasions});
}
final class GetOccasionsErrorState extends VisitorsState {
  final String error;
  GetOccasionsErrorState({required this.error});
}

final class SearchLoadingState extends VisitorsState {}
final class SearchSuccessState extends VisitorsState {
  final List<OccasionEntity> occasions;
  SearchSuccessState({required this.occasions});
}

final class SendFollowRequestLoadingState extends VisitorsState {}
final class SendFollowRequestSuccessState extends VisitorsState {}
final class SendFollowRequestErrorState extends VisitorsState {
  final String message;
  SendFollowRequestErrorState({required this.message});
}

final class ChangeActiveOrdersState extends VisitorsState {}

final class GetBannerDataLoadingState extends VisitorsState {}
final class GetBannerDataSuccessState extends VisitorsState {}
final class GetBannerDataErrorState extends VisitorsState {}

final class GetOccasionDataLoadingState extends VisitorsState {}
final class GetOccasionDataSuccessState extends VisitorsState {}
final class GetOccasionDataErrorState extends VisitorsState {}

final class CreateOccasionLinkDetailsLoadingState extends VisitorsState {}
final class CreateOccasionLinkDetailsSuccessState extends VisitorsState {}
final class CreateOccasionLinkDetailsErrorState extends VisitorsState {}

class GetAnalysisLoadingState extends VisitorsState{}
class GetAnalysisSuccessState extends VisitorsState{}
class GetAnalysisErrorState extends VisitorsState{}

class GetMyPaymentSuccessState extends VisitorsState{}
class GetMyPaymentLoadingState extends VisitorsState{}

class EditOccasionLoadingState extends VisitorsState {}
class EditOccasionSuccessState extends VisitorsState {

}
class EditOccasionErrorState extends VisitorsState {
  final String error;
  EditOccasionErrorState(this.error);
}

class FollowingLoadingState extends VisitorsState{}
class FollowingSuccessState extends VisitorsState{}
class FollowingErrorState extends VisitorsState{
 final String message;
  FollowingErrorState({required this.message});
}

class IsActiveLoading extends VisitorsState{}
class IsActiveSuccess extends VisitorsState{}

class FollowersLoadingState extends VisitorsState{}
class FollowersSuccessState extends VisitorsState{}
class FollowersErrorState extends VisitorsState{
 final  String message;
  FollowersErrorState({required this.message});
}