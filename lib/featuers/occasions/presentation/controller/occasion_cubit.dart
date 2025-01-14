import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'occasion_state.dart';

class OccasionCubit extends Cubit<OccasionState> {
  OccasionCubit() : super(OccasionInitial());

  bool isForMe = true;
  bool isForOther = false;
  bool isPresent = false;
  bool isMoney = true;
  int selectedIndex = 0;
  bool bySharingValue = false;
  int giftValue=0;

  TextEditingController giftNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
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

}
