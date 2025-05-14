import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/data/models/analysis_model.dart';
import 'package:hadawi_app/featuers/occasions/data/repo_imp/occasion_repo_imp.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
part 'occasion_state.dart';

class OccasionCubit extends Cubit<OccasionState> {
  OccasionCubit() : super(OccasionInitial());

  bool isForMe = true;
  bool isPresent = false;
  bool isMoney = false;
  int selectedIndex = 0;
  bool isPublicValue = false;
  bool giftContainsNameValue = false;
  double giftPrice = 0;
  String giftType = '';
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
  TextEditingController giftPriceController = TextEditingController();
  String dropdownOccasionType = '';

  // List of items in our dropdown menu
  List occasionTypeItems = [];

  final GlobalKey<FormState> discountCardKey = GlobalKey<FormState>();

  bool giftWithPackage = true;
  int giftWithPackageType = 0;
  int moneyWithPackageType = 0;


   void resetData() {
    // isForMe = true;
     images = [];
    isPresent = false;
    dropdownOccasionType = '';
    isMoney = false;
    selectedIndex = 0;
    isPublicValue = false;
    giftContainsNameValue = false;
    giftPrice = 0;
    giftType = '';
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

  String selectedGiftPackageImage = '';
  String selectedMoneyPackageImage = '';

  void switchGiftWithPackageType(int value, String image) {
    selectedGiftPackageImage = image;
    giftWithPackageType = value;
    emit(SwitchGiftWithPackageTypeSuccess());
  }

  void switchMoneyWithPackageType(int value, String image) {
    selectedMoneyPackageImage = image;
    moneyWithPackageType = value;
    emit(SwitchGiftWithPackageTypeSuccess());
  }

  void switchGiftWithPackage(bool value) {
    giftWithPackage = value;
    emit(SwitchGiftWithPackageSuccess());
  }

  bool showDeliveryData = false;

  void switchShowDeliveryData() {
    showDeliveryData = !showDeliveryData;
    emit(SwitchShowDeliveryDataSuccess());
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

  void switchGiftType({required bool present}) {
    if(present){
      giftType = 'هدية';
      isPresent = true;
      isMoney = false;
    }else{
      giftType = 'مبلغ مالى';
      isPresent = false;
      isMoney = true;
    }

    emit(SwitchGiftTypeSuccess());
  }

  void switchIsPublic() {
    isPublicValue = !isPublicValue;
    emit(SwitchBySharingSuccess());
  }

  bool switchUpdateIsPublic(bool value) {
    value = !value;
    emit(SwitchUpdatingPublicSuccess());
    return value;
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

  String convertArabicToEnglishNumbers(String input) {
    const arabicToEnglish = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };

    return input.split('').map((char) => arabicToEnglish[char] ?? char).join();
  }

  double totalPriceCalculate=0;

  double getTotalGiftPrice() {
    final text = convertArabicToEnglishNumbers(moneyAmountController.text.trim());
    double giftPriceNumber = double.tryParse(text) ?? 0.0;
    String packagePrice = isPresent?giftWithPackageType.toString():moneyWithPackageType.toString();
    double packagePriceNumber = double.tryParse(packagePrice) ?? 0.0;


    giftPrice = (giftPriceNumber + packagePriceNumber + deliveryTax + serviceTax) - discountValue;

    emit(GetTotalGiftPriceSuccessState());
    return giftPrice;
  }

  final ImagePicker picker = ImagePicker();
  List<File> images = [];

  Future<void> pickGiftImage() async {
    emit(PickImageLoadingState());
    try {
      final List<XFile> pickedImages = await picker.pickMultiImage();
      if (pickedImages != null && pickedImages.isNotEmpty) {
        images = pickedImages.map((xFile) => File(xFile.path)).toList();
        debugPrint('pickedImages: $images');
        emit(PickImageSuccessState());
      } else {
        emit(PickImageErrorState());
      }
    } catch (e) {
      emit(PickImageErrorState());
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      emit(RemovePickedImageSuccessState());
    }
  }
  void removeNetworkImage(int index, List<dynamic> networkImages) {
    if (index >= 0 && index < networkImages.length) {
      networkImages.removeAt(index);
      emit(RemoveNetworkImageSuccessState());
    }
  }

  List<String> imageUrls = [];

  Future<List<String>> uploadImages() async {
    emit(UploadImageLoadingState());
    try {
      List<String> downloadUrls = [];
      for (File image in images) {
        final uploadTask = await firebase_storage.FirebaseStorage.instance
            .ref()
            .child('giftImages/${Uri.file(image.path).pathSegments.last}')
            .putFile(image);

        final downloadUrl = await uploadTask.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      imageUrls = downloadUrls;
      debugPrint('downloadUrls: $downloadUrls');
      emit(UploadImageSuccessState());
      return downloadUrls;
    } catch (error) {
      emit(UploadImageErrorState());
      throw Exception("Failed to upload images: $error");
    }
  }

  Future<void> addOccasion() async {
    emit(AddOccasionLoadingState());

    try {
      final List<String>? imageUrl = isPresent
          ? await uploadImages()
          : [];
      debugPrint('imageUrl: $imageUrl');
      final result = await OccasionRepoImp().addOccasions(
        isForMe: isForMe,
        isActive: true,
        occasionName: "",
        occasionDate: DateTime.now().toString(),
        occasionType: isForMe ? 'مناسبة لى' : 'مناسبة لآخر',
        moneyGiftAmount: 0,
        personId: UserDataFromStorage.uIdFromStorage,
        personName: UserDataFromStorage.userNameFromStorage,
        personPhone: UserDataFromStorage.phoneNumberFromStorage,
        personEmail: UserDataFromStorage.emailFromStorage,
        giftImage: imageUrl ?? [],
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
        packageImage: isPresent? selectedGiftPackageImage : selectedMoneyPackageImage,
        packagePrice: isPresent? giftWithPackageType.toString() : moneyWithPackageType.toString(),
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
    required GlobalKey qrKey,
  }) async {
    File? tempFile;

    try {
      // Start by emitting a loading state
      emit(CaptureAndShareQrLoadingState());

      // Add a delay to ensure the QR code is fully rendered
      await Future.delayed(const Duration(milliseconds: 100));

      // Safely access the render object
      if (!qrKey.currentContext!.mounted) {
        emit(CaptureAndShareQrErrorState());
        return;
      }

      final RenderRepaintBoundary boundary =
      qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Use a lower pixel ratio for iOS - reduces memory pressure
      final ui.Image image = await boundary.toImage(pixelRatio: 1.5);

      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        emit(CaptureAndShareQrErrorState());
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // Create a file in the proper documents directory for iOS
      // Use getApplicationDocumentsDirectory() which is more reliable for sharing on iOS
      // than the temporary directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/QRCode_$timestamp.png';
      tempFile = File(filePath);

      await tempFile.writeAsBytes(pngBytes);

      // For iOS, we need to ensure the file URL can be shared between apps
      final String? shareFilePath = tempFile.path;
      if (shareFilePath == null) {
        emit(CaptureAndShareQrErrorState());
        return;
      }

      // iOS safe sharing approach
      try {
        // On iOS, prefer using the standard Share.shareFiles method
        // The arabic text is wrapped in a try-catch block to isolate any encoding issues
        String sharingText;
        try {
          sharingText = 'قام صديقك $personName بدعوتك للمشاركة في مناسبة له $occasionName للمساهمة بالدفع امسح الباركود لرؤية تفاصيل عن الهدية';
        } catch (e) {
          // Fallback to plain text if there are encoding issues
          sharingText = 'Invitation from $personName for $occasionName';
        }

        // On iOS, we'll use the standard shareFiles method with a subject parameter
        if (Platform.isIOS) {
          await Share.shareFiles(
              [shareFilePath],
              text: sharingText,
              subject: 'Invitation for $occasionName'
          );
        } else {
          // For Android, use the original XFile approach
          await Share.shareXFiles(
            [XFile(shareFilePath)],
            text: sharingText,
          );
        }

        emit(CaptureAndShareQrSuccessState());
      } catch (shareError) {
        print('Error sharing on iOS: $shareError');

        // iOS-specific fallback method
        try {
          // Try with simpler sharing parameters
          await Share.shareFiles(
              [shareFilePath],
              mimeTypes: ['image/png'],
              subject: 'QR Code'
          );
          emit(CaptureAndShareQrSuccessState());
        } catch (fallbackError) {
          print('Fallback iOS share failed: $fallbackError');
          emit(CaptureAndShareQrErrorState());
        }
      }

      // Important: On iOS, don't delete the file immediately
      // Schedule deletion for later to avoid conflicts with sharing
      Future.delayed(const Duration(seconds: 5), () {
        try {
          if (tempFile != null && tempFile.existsSync()) {
            tempFile.deleteSync();
          }
        } catch (e) {
          print('File cleanup error: $e');
        }
      });

    } catch (e) {
      print('Error in QR sharing process: $e');
      emit(CaptureAndShareQrErrorState());

      // Ensure file cleanup even on error
      if (tempFile != null) {
        Future.delayed(const Duration(seconds: 5), () {
          try {
            if (tempFile!.existsSync()) {
              tempFile.deleteSync();
            }
          } catch (e) {
            // Just log cleanup errors
            print('Error cleaning up file: $e');
          }
        });
      }
    }
  }

  var deliveryTax = 0.0;
  List giftPackageListPrice = [];
  List moneyPackageListPrice = [];
  List giftPackageListImage = [];
  List moneyPackageListImage = [];
  var serviceTax = 0.0;

  // get taxes from firebase collection taxs.
  Future<void> getOccasionTaxes() async{
    emit(GetOccasionTaxesLoadingState());

    await FirebaseFirestore.instance.collection('taxs').get().then((value) {
      deliveryTax = double.parse(value.docs[0]['delivery_tax'].toString());
      moneyPackageListPrice = value.docs[0]['packaging_tax'];
      moneyPackageListImage = value.docs[0]['pakaging_image'];
      giftPackageListPrice = value.docs[0]['packaging_gift_tax'];
      giftPackageListImage = value.docs[0]['pakaging_gift_image'];
      occasionTypeItems = value.docs[0]['occasionType'];
      serviceTax = double.parse(value.docs[0]['service_tax'].toString());
      debugPrint('occasionTypeItems: ${value.docs[0]['occasionType']}');
      selectedGiftPackageImage = giftPackageListImage[0].toString();
      giftWithPackageType = int.parse(giftPackageListPrice[0].toString());
      moneyWithPackageType = int.parse(moneyPackageListPrice[0].toString());
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
      final int used = data['used'] ?? 0;
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
        discountValue = discount;
        if(discountValue > giftPrice){
          _showErrorToast("قيمة الخصم أكبر من سعر الهدية");
          return;
        }else{
          giftPrice -= discountValue;
          transaction.update(doc.reference, {
            'used': FieldValue.increment(1),
          });        }
        showDiscountValue = true;
        customToast(
          title: "تم تطبيق الخصم",
          color: ColorManager.primaryBlue,
        );
      });

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
        bundleId: 'com.app.hadawiapp',
        minimumVersion: '1.0.0',
      ),
    );

    final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    debugPrint("shortLink: ${shortLink.shortUrl}");
    occasionLink = shortLink.shortUrl.toString();
    emit(CreateOccasionLinkSuccessState());
    return shortLink.shortUrl.toString();
  }


  Future<void> disableOccasion({required String occasionId, required BuildContext context}) async {
    emit(DisableOccasionLoadingState());
    try {
      // Get all payments for this occasion
      final paymentsSnapshot = await FirebaseFirestore.instance
          .collection('Occasions')
          .doc(occasionId)
          .collection('payments')
          .get();

      // Process refunds for each payment
      for (var element in paymentsSnapshot.docs) {
        String paymentId = element.data()['transactionId'];

        // If there's a transaction ID, process the refund
        if (paymentId.isNotEmpty) {
          await _processRefund(
            paymentId: paymentId,
            amount: element.data()['paymentAmount'].toString() ?? '0.00',
          );
        }
      }

      // Update the occasion to inactive
      await FirebaseFirestore.instance
          .collection('Occasions')
          .doc(occasionId)
          .update({'isActive': false});

      emit(DisableOccasionSuccessState());
    } catch (error) {
      debugPrint('error when disable occasion: $error');
      customToast(title: error.toString(), color: ColorManager.red);
      emit(DisableOccasionErrorState());
    }
  }

  Future<bool> _processRefund({
    required String paymentId,
    required String amount,
  }) async {
    try {
      // API details from your provided cURL command
      const String baseUrl = 'https://eu-test.oppwa.com';
      const String path = '/v1/payments';
      const String entityId = '8a8294174d0595bb014d05d829cb01cd';
      const String authToken = 'OGE4Mjk0MTc0ZDA1OTViYjAxNGQwNWQ4MjllNzAxZDF8OVRuSlBjMm45aA==';

      // Prepare headers
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      // Prepare body
      final body = {
        'entityId': entityId,
        'amount': amount,
        'paymentType': 'RF',
        'currency': "SAR",
      };

      // Make the refund request
      final response = await http.post(
        Uri.parse('$baseUrl$path/$paymentId'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        debugPrint('Refund processed successfully: ${responseData.toString()}');
        return true;
      } else {
        debugPrint('Refund failed with status: ${response.statusCode}, body: ${response.body}');
        return false;
      }
    } catch (error) {
      debugPrint('Error processing refund: $error');
      return false;
    }
  }


  AnalysisModel ?analysisModel;

  String dropdownCity = "";
  String dropdownQuarter = "";

  String selectedCityId = "";

  List<String> allCity = [];
  List<Map<String, dynamic>> allCityMap = [];

  Future<void> getAllCity()async{
    allCity = [];
    emit(GetAllCityLoadingState());
    try{
      var response = await FirebaseFirestore.instance.collection('city').get();
      response.docs.forEach((element) {
        allCity.add(element.data()['name']);
        allCityMap.add({
          'name': element.data()['name'],
          'id': element.data()['id'],
        });
      });

      emit(GetAllCitySuccessState());
    }catch(e){
      debugPrint('error in get all city $e');
      emit(GetAllCityErrorState());
    }

  }


  Future<void> getCityId(String city)async{
    for (var element in allCityMap) {
      if(element['name'] == city){
        selectedCityId = element['id'];
        debugPrint('city id: $selectedCityId');
        break;
      }
    }
  }

  List<String> allQuarters = [];

  Future<void> getQuarters({required String city}) async {
    allQuarters = [];
    emit(GetAllQuartersLoadingState());

    await getCityId(city);
    try{
      FirebaseFirestore.instance.collection('city').doc(selectedCityId).collection('quarters').get().then((value) {
        value.docs.forEach((element) {
          allQuarters.add(element.data()['name']);
        });
      });
      emit(GetAllQuartersSuccessState());
    }catch(e){
      debugPrint('error in get all Quarters $e');
      emit(GetAllQuartersErrorState());
    }
  }

List<dynamic> urls=[];
  Future<void> updateOccasion({
    required String occasionId,
  }) async {
    emit(UpdateOccasionLoadingState());
    try {
      final List<String>? imageUrl = images.isNotEmpty ? await uploadImages():null;
      await FirebaseFirestore.instance
          .collection('Occasions')
          .doc(occasionId)
          .update({
        'occasionName': occasionNameController.text,
        'personName': nameController.text,
        'personPhone': giftReceiverNumberController.text,
        'giftName': giftNameController.text,
        'giftLink': linkController.text,
        'giftPrice': double.parse(moneyAmountController.text),
        'giftType': giftType,
        'city': dropdownCity,
        'district': giftDeliveryStreetController.text,
        'giftCard': moneyGiftMessageController.text,
        'receiverName':  giftReceiverNameController.text ,
        'receiverPhone': giftReceiverNumberController.text,
        'occasionImage': imageUrl?? urls,
        'note': giftDeliveryNoteController.text,
        'type': dropdownOccasionType,
        'isPrivate': isPublicValue,
      });

      emit(UpdateOccasionSuccessState());
    } catch (e) {
      debugPrint("error when edit occasion: ${e.toString()}");
      if (kDebugMode) {
        print(e.toString());
        emit(UpdateOccasionErrorState(error:  e.toString()));
      }
    }
  }
}
