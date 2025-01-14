part of 'occasion_cubit.dart';

sealed class OccasionState {}

final class OccasionInitial extends OccasionState {}
final class SwitchForWhomOccasionSuccess extends OccasionState {}
final class SwitchGiftKindSuccess extends OccasionState {}
final class SwitchBySharingSuccess extends OccasionState {}
