import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/data/models/analysis_model.dart';
import 'package:hadawi_app/featuers/occasions/data/repo_imp/occasion_repo_imp.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  TextEditingController discountCodeController = TextEditingController();
  String dropdownOccasionType = '';

  // List of items in our dropdown menu
  List occasionTypeItems = [];

  final GlobalKey<FormState> discountCardKey = GlobalKey<FormState>();

  bool giftWithPackage = true;
  int giftWithPackageType = 0;


   void resetData() {
    // isForMe = true;
    isPresent = true;
    dropdownOccasionType = '';
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
    dropdownCity='';
    giftDeliveryStreetController.clear();
    emit(ResetDataSuccessState());
  }

  String selectedPackageImage = '';

  void switchGiftWithPackageType(int value, String image) {
    selectedPackageImage = image;
    giftWithPackageType = value;
    emit(SwitchGiftWithPackageTypeSuccess());
  }

  void switchGiftWithPackage(bool value) {
    giftWithPackage = value;
    emit(SwitchGiftWithPackageSuccess());
  }


  bool showGiftCard = false;
  bool showNote = false;


  void switchShowGiftCard() {
    showGiftCard = !showGiftCard;
    emit(SwitchShowGiftCardSuccess());
  }

  void switchShowNote() {
    showNote = !showNote;
    emit(SwitchShowNoteSuccess());
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

  double totalPriceCalculate=0;
  double getAppCommission() {
     print('moneyAmountController.text ${moneyAmountController.text}');
    double giftPriceNumber = double.parse(moneyAmountController.text);
    double appCommission = giftPriceNumber * serviceTax;
     totalPriceCalculate= appCommission;
    emit(GetTotalGiftPriceSuccessState());
    return appCommission;
  }

  double getTotalGiftPrice() {
    final text = moneyAmountController.text.trim();
    double giftPriceNumber = double.tryParse(text) ?? 0.0;
    double packagePriceNumber = double.tryParse(giftWithPackageType.toString()) ?? 0.0;

    double appCommission = giftPriceNumber * serviceTax;

    if (giftType == 'مبلغ مالي' && giftWithPackage == false) {
      giftPrice = (giftPriceNumber + packagePriceNumber + appCommission) - discountValue;
    } else {
      giftPrice = (giftPriceNumber + packagePriceNumber + appCommission + deliveryTax) - discountValue;
    }

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
      final String? imageUrl = isPresent
          ? await uploadImage()
          : null;
      debugPrint('imageUrl: $imageUrl');
      final result = await OccasionRepoImp().addOccasions(
        isForMe: isForMe,
        occasionName: occasionNameController.text,
        occasionDate: DateTime.now().toString(),
        occasionType: isForMe ? 'مناسبة لى' : 'مناسبة لآخر',
        moneyGiftAmount: 0,
        personId: UserDataFromStorage.uIdFromStorage,
        personName: UserDataFromStorage.userNameFromStorage,
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
        city: dropdownCity,
        district: giftDeliveryStreetController.text,
        ibanNumber: ibanNumberController.text,
        giftCard: moneyGiftMessageController.text,
        isContainName: giftContainsNameValue,
        isPrivate: isPublicValue,
        discount: discountValue,
        appCommission: totalPriceCalculate,
        deliveryPrice: deliveryTax,
        type: dropdownOccasionType??'',
      );
      result.fold((failure) {
        emit(AddOccasionErrorState(error: failure.message));
      }, (occasion)async {
        int openCount = 0;
        await FirebaseFirestore.instance.collection('analysis').doc('x6cWwImrRB3PIdVfcHnP').get().then((value)async {
          openCount = value.data()!['openOccasions'];
          await FirebaseFirestore.instance.collection('analysis').doc('x6cWwImrRB3PIdVfcHnP').update({
            'openOccasions': openCount
          });
        });

        emit(AddOccasionSuccessState(occasion: occasion));
      });
    } catch (error) {
      debugPrint('*************');
      debugPrint('error: $error');
      emit(AddOccasionErrorState(error: error.toString()));
    }
  }


  Future<void> captureAndShareQr({
    required String occasionName,
    required String personName,
    required GlobalKey qrKey
  }) async {
    try {
      // Start by emitting a loading state (if needed)
      emit(CaptureAndShareQrLoadingState());

      RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/occasion_qr.png').create();
      await file.writeAsBytes(pngBytes);

      final shareResult = await Share.shareXFiles(
        [XFile(file.path)],
        text: 'قام صديقك $personName بدعوتك للمشاركة في مناسبة $occasionName للمساهمة بالدفع امسح الباركود لرؤية تفاصيل عن الهدية',
      );

      // Check if sharing completed or was canceled
      if (shareResult.status == ShareResultStatus.success ||
          shareResult.status == ShareResultStatus.dismissed) {
        emit(CaptureAndShareQrSuccessState());
      } else {
        emit(CaptureAndShareQrErrorState());
      }

      // Cleanup temporary file
      if (await file.exists()) {
        await file.delete();
      }

    } catch (e) {
      print('Error sharing QR code: $e');
      emit(CaptureAndShareQrErrorState());
    }
  }

  var deliveryTax = 0.0;
  List packageListPrice = [];
  List packageListImage = [];
  var serviceTax = 0.0;

  // get taxes from firebase collection taxs.
  Future<void> getOccasionTaxes() async{
    emit(GetOccasionTaxesLoadingState());

    await FirebaseFirestore.instance.collection('taxs').get().then((value) {
      deliveryTax = double.parse(value.docs[0]['delivery_tax'].toString());
      packageListPrice = value.docs[0]['packaging_tax'];
      packageListImage = value.docs[0]['pakaging_image'];
      occasionTypeItems = value.docs[0]['occasionType'];
      serviceTax = double.parse(value.docs[0]['service_tax'].toString());
      debugPrint('occasionTypeItems: ${value.docs[0]['occasionType']}');
      emit(GetOccasionTaxesSuccessState());
    }).catchError((error){
      debugPrint('error when get occasion taxes: $error');
      emit(GetOccasionTaxesErrorState());
    });

  }
  
  
  bool showDiscountField = false;
  
  void switchDiscountField() {
    showDiscountField = !showDiscountField;
    emit(SwitchDiscountFieldSuccess());
  }

  double discountValue = 0.0;
  bool showDiscountValue = false;

  Future<void> getDiscountCode() async {
    try {
      emit(GetOccasionDiscountLoadingState());
      final String inputCode = discountCodeController.text.trim();
      if (inputCode.isEmpty) {
        _showErrorToast("يرجى إدخال كود الخصم");
        emit(GetOccasionDiscountSuccessState());
        return;
      }
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("PromoCodes")
          .where('code', isEqualTo: inputCode)
          .limit(1)
          .get(const GetOptions(source: Source.serverAndCache));
      if (snapshot.docs.isEmpty) {
        _showErrorToast("كود الخصم غير صحيح, أعد كتابته مرة أخرى");
        emit(GetOccasionDiscountSuccessState());
        return;
      }
      final DocumentSnapshot doc = snapshot.docs.first;
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      final DateTime expiryDate = DateTime.parse(data['expiryDate'] as String);
      final int maxUsage = data['maxUsage'] as int;
      final int used = data['used'] as int;
      final double discount = (data['discount'] as num).toDouble();

      if (maxUsage <= used || expiryDate.isBefore(DateTime.now())) {
        _showErrorToast("كود الخصم غير صالح");
        emit(GetOccasionDiscountSuccessState());
        return;
      }
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final freshDoc = await transaction.get(doc.reference);
        final freshData = freshDoc.data() as Map<String, dynamic>;
        if (freshData['used'] >= freshData['maxUsage']) {
          throw Exception('Discount code usage limit reached');
        }
        discountValue = giftPrice * discount;
        giftPrice -= discountValue;
        transaction.update(doc.reference, {
          'used': FieldValue.increment(1),
        });
      });

      showDiscountValue = true;
      customToast(
        title: "تم تطبيق الخصم",
        color: ColorManager.primaryBlue,
      );
      emit(GetOccasionDiscountSuccessState());
    } catch (error) {
      showDiscountValue = false;
      debugPrint('Error applying discount code: $error');
      _showErrorToast("حدث خطأ أثناء تطبيق الخصم");
      emit(GetOccasionDiscountErrorState());
    }
  }

  void _showErrorToast(String message) {
    customToast(
      title: message,
      color: ColorManager.red,
    );
  }

  String occasionLink = '';

  Future<String> createDynamicLink(String occasionId) async {
    emit(CreateOccasionLinkLoadingState());
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://hadawiapp.page.link',
      link: Uri.parse('https://hadawiapp.page.link/Occasion-details/$occasionId'),
      androidParameters: const AndroidParameters(
        packageName: 'com.app.hadawi_app',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.app.hadawiApp',
        minimumVersion: '1.0.0',
      ),
    );

    final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    debugPrint("shortLink: ${shortLink.shortUrl}");
    occasionLink = shortLink.shortUrl.toString();
    emit(CreateOccasionLinkSuccessState());
    return shortLink.shortUrl.toString();
  }


  AnalysisModel ?analysisModel;

  String dropdownCity = "";
  List<String> saudiCities = [
    // منطقة الرياض
    "الرياض", "الدرعية", "الخرج", "الدوادمي", "المجمعة", "الزلفي", "شقراء",
    "وادي الدواسر", "الأفلاج", "عفيف", "حوطة بني تميم", "السليل", "ثادق",
    "حريملاء", "رماح", "المزاحمية", "ضرماء", "مرات",

    // منطقة مكة المكرمة
    "مكة المكرمة", "جدة", "الطائف", "رابغ", "الليث", "القنفذة", "الخرمة",
    "الكامل", "خليص", "الجموم", "رنية", "تربة",

    // منطقة المدينة المنورة
    "المدينة المنورة", "ينبع", "العلا", "بدر", "الحناكية", "خيبر", "المهد",

    // المنطقة الشرقية
    "الدمام", "الخبر", "الظهران", "الجبيل", "القطيف", "الأحساء", "رأس تنورة",
    "الخفجي", "النعيرية", "حفر الباطن", "قرية العليا", "بقيق",

    // منطقة القصيم
    "بريدة", "عنيزة", "الرس", "المذنب", "البكيرية", "البدائع", "الأسياح",
    "النبهانية", "عيون الجواء", "رياض الخبراء", "الشماسية",

    // منطقة عسير
    "أبها", "خميس مشيط", "بيشة", "محايل عسير", "النماص", "رجال ألمع",
    "سراة عبيدة", "ظهران الجنوب", "تثليث", "أحد رفيدة", "المجاردة", "البرك",

    // منطقة حائل
    "حائل", "بقعاء", "الشنان", "الغزالة", "الحائط", "السليمي", "سميراء",

    // منطقة تبوك
    "تبوك", "الوجه", "ضباء", "أملج", "حقل", "البدع",

    // منطقة نجران
    "نجران", "شرورة", "حبونا", "يدمة", "بدر الجنوب", "ثار", "خباش",

    // منطقة جازان
    "جازان", "صبيا", "أبو عريش", "صامطة", "فرسان", "العارضة", "الداير بني مالك",
    "أحد المسارحة", "بيش", "العيدابي", "الدرب", "الحرث",

    // منطقة الباحة
    "الباحة", "بلجرشي", "المندق", "المخواة", "العقيق", "قلوة",

    // منطقة الجوف
    "سكاكا", "القريات", "دومة الجندل",

    // منطقة الحدود الشمالية
    "عرعر", "رفحاء", "طريف"
  ];



}
