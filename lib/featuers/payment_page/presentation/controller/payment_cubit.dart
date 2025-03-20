import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hadawi_app/featuers/payment_page/date/models/payment_model.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_states.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentCubit extends Cubit<PaymentStates> {

  PaymentCubit() : super(PaymentInitialState());

  static PaymentCubit get(context) => BlocProvider.of(context);


  TextEditingController paymentAmountController = TextEditingController();
  TextEditingController paymentPayerNameController = TextEditingController();
  GlobalKey<FormState> paymentFormKey = GlobalKey<FormState>();


  
  
  Future<void> addPaymentData({required BuildContext context, required String status ,required String transactionId,required String occasionId, required String remainingPrince ,required String occasionName, required double paymentAmount})async{
    emit(PaymentAddLoadingState());

    double paymentCounterValue = double.parse(paymentAmountController.text);

    await FirebaseFirestore.instance.collection("Occasions").doc(occasionId).update({
      "moneyGiftAmount": paymentAmount + paymentCounterValue,
    });

    await FirebaseFirestore.instance.collection("Occasions").doc(occasionId).collection("payments").add({
      "paymentAmount": paymentCounterValue,
      "paymentDate": DateTime.now().toString(),
      "remainingPrince": remainingPrince,
      "paymentId": "",
      "paymentStatus": status,
      "transactionId": transactionId,
      "date": DateTime.now().toString(),
      "occasionId": occasionId,
      "occasionName": occasionName,
      "payerName": paymentPayerNameController.text,
      "personId": UserDataFromStorage.uIdFromStorage,
      "personName": UserDataFromStorage.userNameFromStorage,
      "personPhone": UserDataFromStorage.phoneNumberFromStorage,
      "personEmail": UserDataFromStorage.emailFromStorage,
    }).then((value)async{
      await FirebaseFirestore.instance.collection("Occasions").doc(occasionId).collection("payments").doc(value.id).update({"paymentId": value.id});
      await FirebaseFirestore.instance.collection("payments").doc(value.id).set({
        "paymentAmount": paymentCounterValue,
        "paymentDate": DateTime.now().toString(),
        "remainingPrince": remainingPrince,
        "paymentId": value.id,
        "paymentStatus": status,
        "transactionId": transactionId,
        "date": DateTime.now().toString(),
        "occasionId": occasionId,
        "payerName": paymentPayerNameController.text,
        "occasionName": occasionName,
        "personId": UserDataFromStorage.uIdFromStorage,
        "personName": UserDataFromStorage.userNameFromStorage,
        "personPhone": UserDataFromStorage.phoneNumberFromStorage,
        "personEmail": UserDataFromStorage.emailFromStorage,
      }).then((value){
        debugPrint("payment added to payments collection");
        emit(PaymentAddSuccessState());
      }).catchError((error){
        debugPrint("error when add payment to payments collection : ${error.toString()}");
        emit(PaymentAddErrorState());
      });
      paymentAmountController.clear();
      paymentPayerNameController.clear();
      paymentStatusList.clear();
      debugPrint("payment added");
      emit(PaymentAddSuccessState());
    }).catchError((error){
      debugPrint("error when add payment : ${error.toString()}");
      emit(PaymentAddErrorState());
    });
    
  }



  List<PaymentModel> occasionPaymentsList = [];


  Future<void> getOccasionPaymentsList({required String occasionId})async{
    occasionPaymentsList = [];
    emit(PaymentGetLoadingState());
    await FirebaseFirestore.instance.collection("Occasions").doc(occasionId).collection("payments").get().then((value)async{
      for (var element in value.docs) {
        occasionPaymentsList.add(PaymentModel.fromMap(element.data()));
      }
      debugPrint("payments got==> ${occasionPaymentsList.length}");
      emit(PaymentGetSuccessState());
    }).catchError((error){
      debugPrint("error when get payments : ${error.toString()}");
      emit(PaymentGetErrorState());
    });
  }

  Future<Map<String, dynamic>> getCheckoutId({
    required String email,
    required String givenName,
    required String surname,
    required String street,
    required String city,
    required String state,
    required String postcode,
    required String merchantTransactionId,
  }) async {
    emit(PaymentHyperPayLoadingState());

    try {
      // Format amount to ensure it has 2 decimal places
      String formattedAmount = double.tryParse(paymentAmountController.text)?.toStringAsFixed(2) ?? "0.00";

      final response = await http.post(
        Uri.parse("https://eu-test.oppwa.com/v1/checkouts"),
        headers: {
          "Authorization": "Bearer OGFjN2E0Yzc5NWEwZjcyZjAxOTVhMzc1MjY1NjAzZjV8Sz9DcD9QeFV4PTVGUWJ1S2MlUHU=",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "entityId": "8ac7a4c795a0f72f0195a375b38c03f9",
          "amount": formattedAmount,
          "currency": "SAR",
          "paymentType": "DB",
          "customParameters[3DS2_enrolled]": "true",
          "customParameters[3DS2.challengeIndicator]": "04",
          "customParameters[3DS2.authenticationFlow]": "challenge",
          "merchantTransactionId": merchantTransactionId,
          "customer.email": email,
          "customer.givenName": givenName,
          "customer.surname": surname,
          "billing.street1": street,
          "billing.city": city,
          "billing.state": state,
          "billing.country": "SA",
          "billing.postcode": postcode,
          "shopperResultUrl": "https://hadawi.netlify.app/payment-result",
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        debugPrint("Checkout ID response: ${data.toString()}");

        // Check if the response contains the expected fields
        if (data.containsKey("id")) {
          final result = {
            "checkoutId": data["id"],
            "fullResponse": data
          };

          emit(PaymentHyperPaySuccessState());
          return result;
        } else {
          debugPrint("Missing required fields in response: ${data.toString()}");
          emit(PaymentHyperPayErrorState());
          return {
            "error": "Invalid response format",
            "fullResponse": data
          };
        }
      } else {
        debugPrint("Error response: ${response.statusCode} - ${response.body}");
        emit(PaymentHyperPayErrorState());
        return {
          "error": "HTTP Error ${response.statusCode}",
          "message": response.body
        };
      }
    } catch (e) {
      debugPrint("Exception when getting HyperPay checkout ID: ${e.toString()}");
      emit(PaymentHyperPayErrorState());
      return {
        "error": "Exception",
        "message": e.toString()
      };
    }
  }

  List<Map<String, dynamic>> paymentStatusList = [];

  Future<Map<String, dynamic>> checkPaymentStatus(String checkoutId, BuildContext context) async {
    final response = await http.get(
      Uri.parse("https://eu-test.oppwa.com/v1/checkouts/$checkoutId/payment?entityId=8ac7a4c795a0f72f0195a375b38c03f9"),
      headers: {
        "Authorization": "Bearer OGFjN2E0Yzc5NWEwZjcyZjAxOTVhMzc1MjY1NjAzZjV8Sz9DcD9QeFV4PTVGUWJ1S2MlUHU=",
      },
    );

    final data = jsonDecode(response.body);
    final resultCode = data['result']['code'];
    if(resultCode != "200.300.404"){
      paymentStatusList.add(data);
    }
    // if(resultCode == "200.300.404" && ){
    //   Navigator.pop(context);
    // }
    // else if (resultCode.startsWith('000.000.') ||
    //     resultCode.startsWith('000.100.') ||
    //     resultCode.startsWith('000.200.')) {
    //   customToast(title: "Payment Successful", color: ColorManager.success);
    //   if(UserDataFromStorage.userIsGuest){
    //     context.replace(AppRouter.visitors);
    //     emit(PaymentHyperPaySuccessState());
    //   }else{
    //     context.replace(AppRouter.home);
    //     emit(PaymentHyperPaySuccessState());
    //   }
    //   debugPrint("✅ Payment Successful");
    // }
    // // Pending codes typically start with 000.200.
    // else if (resultCode.startsWith('000.200.')) {
    //   debugPrint("⏳ Payment Pending");
    // }
    // // Failure codes can vary
    // else {
    //   debugPrint("❌ Payment Failed");
    // }
    emit(PaymentHyperPaySuccessState());
    debugPrint("Payment Status Response: ${data.toString()}");

    return data;
  }


}