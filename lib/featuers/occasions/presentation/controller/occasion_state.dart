part of 'occasion_cubit.dart';

sealed class OccasionState {}

final class OccasionInitial extends OccasionState {}
final class SwitchForWhomOccasionSuccess extends OccasionState {}
final class SwitchGiftTypeSuccess extends OccasionState {}
final class SwitchGiftKindSuccess extends OccasionState {}
final class SwitchBySharingSuccess extends OccasionState {}
final class SetOccasionDateState extends OccasionState {}
final class AddOccasionLoadingState extends OccasionState {}
final class PickImageLoadingState extends OccasionState {}
final class PickImageSuccessState extends OccasionState {}
final class PickImageErrorState extends OccasionState {}
final class RemovePickedImageSuccessState extends OccasionState {}
final class UploadImageLoadingState extends OccasionState {}
final class UploadImageSuccessState extends OccasionState {}
final class UploadImageErrorState extends OccasionState {}
final class AddOccasionSuccessState extends OccasionState {
  final OccasionEntity occasion;
  AddOccasionSuccessState({required this.occasion});
}
final class AddOccasionErrorState extends OccasionState {
  final String error;
  AddOccasionErrorState({required this.error});
}


