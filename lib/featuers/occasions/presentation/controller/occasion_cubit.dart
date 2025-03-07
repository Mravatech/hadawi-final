import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/data/repo_imp/occasion_repo_imp.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'occasion_state.dart';

class OccasionCubit extends Cubit<OccasionState> {
  OccasionCubit() : super(OccasionInitial());

  bool isForMe = true;
  bool isPresent = true;
  bool isMoney = false;
  int selectedIndex = 0;
  bool isPublicValue = false;
  bool giftContainsNameValue = false;
  double giftPrice = 0;
  String giftType = 'هدية';
  GlobalKey<FormState> forMeFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> forOtherFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> moneyFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> deliveryFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> giftFormKey = GlobalKey<FormState>();
  TextEditingController giftNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController occasionDateController = TextEditingController();
  TextEditingController moneyReceiveDateController = TextEditingController();
  TextEditingController moneyAmountController = TextEditingController();
  TextEditingController occasionNameController = TextEditingController();
  TextEditingController newOccasionNameController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController ibanNumberController = TextEditingController();
  TextEditingController giftReceiverNameController = TextEditingController();
  TextEditingController giftReceiverNumberController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController moneyGiftMessageController = TextEditingController();
  TextEditingController giftDeliveryNoteController = TextEditingController();
  TextEditingController giftDeliveryCityController = TextEditingController();
  TextEditingController giftDeliveryStreetController = TextEditingController();
  final GlobalKey qrKey = GlobalKey();

  bool giftWithPackage = true;
  int giftWithPackageType = 50;


   void resetData() {
    // isForMe = true;
    isPresent = true;
    isMoney = false;
    selectedIndex = 0;
    isPublicValue = false;
    giftContainsNameValue = false;
    giftPrice = 0;
    giftType = 'هدية';
    giftNameController.clear();
    nameController.clear();
    occasionDateController.clear();
    moneyReceiveDateController.clear();
    moneyAmountController.clear();
    occasionNameController.clear();
    newOccasionNameController.clear();
    linkController.clear();
    ibanNumberController.clear();
    giftReceiverNameController.clear();
    giftReceiverNumberController.clear();
    bankNameController.clear();
    moneyGiftMessageController.clear();
    giftDeliveryNoteController.clear();
    giftDeliveryCityController.clear();
    giftDeliveryStreetController.clear();
    emit(ResetDataSuccessState());
  }

  void switchGiftWithPackageType(int value) {
    giftWithPackageType = value;
    emit(SwitchGiftWithPackageTypeSuccess());
  }

  void switchGiftWithPackage(bool value) {
    giftWithPackage = value;
    emit(SwitchGiftWithPackageSuccess());
  }

  void switchForWhomOccasion() {
    if (isForMe) {
      isForMe = false;
      selectedIndex = 1;
      UserDataFromStorage.setIsForMe(false);
      debugPrint('isForMe $isForMe');
    } else {
      isForMe = true;
      selectedIndex = 0;
      UserDataFromStorage.setIsForMe(true);
      debugPrint('isForMe $isForMe');
    }
    emit(SwitchForWhomOccasionSuccess());
  }

  void switchGiftType() {
    isPresent = !isPresent;
    isMoney = !isMoney;

    emit(SwitchGiftTypeSuccess());
  }

  void switchIsPublic() {
    isPublicValue = !isPublicValue;
    emit(SwitchBySharingSuccess());
  }

  void switchGiftContainsName() {
    giftContainsNameValue = !giftContainsNameValue;
    emit(SwitchGiftContainsNameSuccess());
  }

  void setOccasionDate({required DateTime brithDateValue}) {
    occasionDateController.text =
        DateFormat('yyyy-MM-dd').format(brithDateValue);
    emit(SetOccasionDateState());
  }

  void setMoneyReceiveDate({required DateTime brithDateValue}) {
    moneyReceiveDateController.text = DateFormat('yyyy-MM-dd').format(brithDateValue);
    emit(SetMoneyReceiveDateState());
  }

  double getTotalGiftPrice() {
     double giftPriceNumber = double.parse(moneyAmountController.text);
     double packagePriceNumber = double.parse(giftWithPackageType.toString());
     double appCommission = giftPriceNumber * serviceTax;
     giftPrice = giftPriceNumber + packagePriceNumber + appCommission;
     emit(GetTotalGiftPriceSuccessState());
     return giftPrice;
  }

  var picker = ImagePicker();

  File? image;

  Future<void> pickGiftImage() async {
    emit(PickImageLoadingState());
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
      emit(PickImageSuccessState());
    } else {
      emit(PickImageErrorState());
    }
    emit(PickImageErrorState());
  }

  void removeImage() {
    image = null;
    emit(RemovePickedImageSuccessState());
  }

  Future<String> uploadImage() async {
    emit(UploadImageLoadingState());
    try {
      final uploadTask = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('giftImages/${Uri.file(image!.path).pathSegments.last}')
          .putFile(image!);

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      emit(UploadImageSuccessState());
      return downloadUrl;
    } catch (error) {
      emit(UploadImageErrorState());
      throw Exception("Failed to upload image: $error");
    }
  }

  Future<void> addOccasion() async {
    emit(AddOccasionLoadingState());

    try {
      final String? imageUrl = UserDataFromStorage.giftType == '' ||
              UserDataFromStorage.giftType == 'هدية'
          ? await uploadImage()
          : null;
      final result = await OccasionRepoImp().addOccasions(
        isForMe: isForMe,
        occasionName: occasionNameController.text,
        occasionDate: occasionDateController.text,
        occasionType: isForMe ? 'مناسبة لى' : 'مناسبة لآخر',
        moneyGiftAmount: 0,
        personId: UserDataFromStorage.uIdFromStorage,
        personName: nameController.text,
        personPhone: UserDataFromStorage.phoneNumberFromStorage,
        personEmail: UserDataFromStorage.emailFromStorage,
        giftImage: imageUrl ?? '',
        giftName: giftNameController.text,
        giftLink: linkController.text,
        giftPrice: giftPrice,
        giftType: isPresent? 'هدية':"مبلغ مالى",
        isSharing: isPublicValue,
        receiverName: giftReceiverNameController.text,
        receiverPhone: giftReceiverNumberController.text,
        bankName: bankNameController.text,
        note: giftDeliveryNoteController.text,
        city: giftDeliveryCityController.text,
        district: giftDeliveryStreetController.text,
        ibanNumber: ibanNumberController.text,
        receivingDate: moneyReceiveDateController.text,
        giftCard: moneyGiftMessageController.text,
        isContainName: giftContainsNameValue,
        isPrivate: isPublicValue,
      );
      result.fold((failure) {
        emit(AddOccasionErrorState(error: failure.message));
      }, (occasion) {

        emit(AddOccasionSuccessState(occasion: occasion));
      });
    } catch (error) {
      debugPrint('*************');
      debugPrint('error: $error');
      emit(AddOccasionErrorState(error: error.toString()));
    }
  }


  Future<void> captureAndShareQr({required String occasionName}) async {
    try {
      RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/occasion_qr.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Check out this occasion QR code!, to pay for ($occasionName)',
      );
      emit(CaptureAndShareQrSuccessState());
    } catch (e) {
      print('Error sharing QR code: $e');
      emit(CaptureAndShareQrErrorState());
    }
  }

  var deliveryTax = 0.0;
  List packageListPrice = [];
  var serviceTax = 0.0;

  // get taxes from firebase collection taxs.
  Future<void> getOccasionTaxes() async{
    emit(GetOccasionTaxesLoadingState());

    FirebaseFirestore.instance.collection('taxs').get().then((value) {
      deliveryTax = double.parse(value.docs[0]['delivery_tax'].toString());
      packageListPrice = value.docs[0]['packaging_tax'];
      serviceTax = double.parse(value.docs[0]['service_tax'].toString());
      emit(GetOccasionTaxesSuccessState());
    }).catchError((error){
      debugPrint('error when get occasion taxes: $error');
      emit(GetOccasionTaxesErrorState());
    });

  }

}
