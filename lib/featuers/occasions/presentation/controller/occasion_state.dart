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
final class RemoveNetworkImageSuccessState extends OccasionState {}
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

final class SwitchGiftWithPackageSuccess extends OccasionState {}
final class SwitchGiftWithPackageTypeSuccess extends OccasionState {}
final class SetMoneyReceiveDateState extends OccasionState {}
final class SwitchGiftContainsNameSuccess extends OccasionState {}
final class ResetDataSuccessState extends OccasionState {}
final class GetTotalGiftPriceSuccessState extends OccasionState {}
final class CaptureAndShareQrLoadingState extends OccasionState {}
final class CaptureAndShareQrSuccessState extends OccasionState {}
final class CaptureAndShareQrErrorState extends OccasionState {}

class SaveQrLoadingState extends OccasionState {}
class SaveQrSuccessState extends OccasionState {}
class SaveQrErrorState extends OccasionState {}

final class GetOccasionTaxesLoadingState extends OccasionState {}
final class GetOccasionTaxesSuccessState extends OccasionState {}
final class GetOccasionTaxesErrorState extends OccasionState {}


final class GetOccasionDiscountLoadingState extends OccasionState {}
final class GetOccasionDiscountSuccessState extends OccasionState {}
final class GetOccasionDiscountErrorState extends OccasionState {}

final class SwitchDiscountFieldSuccess extends OccasionState {}

final class CreateOccasionLinkLoadingState extends OccasionState {}
final class CreateOccasionLinkSuccessState extends OccasionState {}
final class CreateOccasionLinkErrorState extends OccasionState {}

final class SwitchShowNoteSuccess extends OccasionState {}
final class SwitchShowGiftCardSuccess extends OccasionState {}
final class SwitchShowDeliveryDataSuccess extends OccasionState {}
final class UpdateOccasionLoadingState extends OccasionState {}
final class UpdateOccasionSuccessState extends OccasionState {}
final class UpdateOccasionErrorState extends OccasionState {
  final String error;
  UpdateOccasionErrorState({required this.error});
}

final class DisableOccasionLoadingState extends OccasionState {}
final class DisableOccasionSuccessState extends OccasionState {}
final class DisableOccasionErrorState extends OccasionState {}



