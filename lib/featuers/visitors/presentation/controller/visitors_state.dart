part of 'visitors_cubit.dart';

@immutable
sealed class VisitorsState {}

final class VisitorsInitial extends VisitorsState {}
final class GetOccasionsLoadingState extends VisitorsState {}
final class GetOccasionsSuccessState extends VisitorsState {
  final List<OccasionEntity> occasions;
  GetOccasionsSuccessState({required this.occasions});
}
final class GetOccasionsErrorState extends VisitorsState {
  final String error;
  GetOccasionsErrorState({required this.error});
}
