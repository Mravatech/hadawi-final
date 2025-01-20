import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/data/repo_imp/occasion_repo_imp.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:intl/intl.dart';

part 'occasion_state.dart';

class OccasionCubit extends Cubit<OccasionState> {
  OccasionCubit() : super(OccasionInitial());

  bool isForMe = true;
  bool isForOther = false;
  bool isPresent = false;
  bool isMoney = true;
  int selectedIndex = 0;
  bool bySharingValue = false;
  int giftValue = 0;

  TextEditingController giftNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController occasionDateController = TextEditingController();
  TextEditingController moneyAmountController = TextEditingController();
  TextEditingController occasionNameController = TextEditingController();
  TextEditingController newOccasionNameController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController ibanNumberController = TextEditingController();
  TextEditingController accountOwnerNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();

  void switchForWhomOccasion() {
    if (isForMe) {
      isForMe = false;
      isForOther = true;
      selectedIndex = 1;
    } else {
      isForMe = true;
      isForOther = false;
      selectedIndex = 0;
    }
    emit(SwitchForWhomOccasionSuccess());
  }

  void switchGiftKind() {
    if (isMoney) {
      isMoney = false;
      isPresent = true;
    } else {
      isMoney = true;
      isPresent = false;
    }
    emit(SwitchGiftKindSuccess());
  }

  void switchBySharing() {
    bySharingValue = !bySharingValue;
    emit(SwitchBySharingSuccess());
  }

  void setOccasionDate({required DateTime brithDateValue}) {
    occasionDateController.text =
        DateFormat('yyyy-MM-dd').format(brithDateValue);
    emit(SetOccasionDateState());
  }

  Future<void> addOccasion(
      {required String id,
      required bool isForMe,
      required String occasionName,
      required String occasionDate,
      required String occasionId,
      required String occasionType,
      required String moneyGiftAmount,
      required String personId,
      required String personName,
      required String personPhone,
      required String personEmail,
      required String giftImage,
      required String giftName,
      required String giftLink,
      required int giftPrice,
      required String giftType}) async {
    emit(AddOccasionLoadingState());
    final result = await OccasionRepoImp().addOccasions(
        id: id,
        isForMe: this.isForMe,
        occasionName: occasionNameController.text,
        occasionDate: occasionDateController.text,
        occasionId: occasionId,
        occasionType: this.isForMe ? 'مناسبة لى' : 'مناسبة لآخر',
        moneyGiftAmount: moneyAmountController.text,
        personId: UserDataFromStorage.uIdFromStorage,
        personName: UserDataFromStorage.userNameFromStorage,
        personPhone: UserDataFromStorage.phoneNumberFromStorage,
        personEmail: UserDataFromStorage.emailFromStorage,
        giftImage: giftImage,
        giftName: giftNameController.text,
        giftLink: linkController.text,
        giftPrice: giftValue,
        giftType: giftType);
    result.fold((failure) {
      emit(AddOccasionErrorState(error: failure.message));
    }, (occasion) {
      emit(AddOccasionSuccessState(occasion: occasion));
    });
  }
}
