import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/payment_page/date/models/payment_model.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_states.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../view/apply_payment.dart';

class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit() : super(PaymentInitialState());

  static PaymentCubit get(context) => BlocProvider.of(context);

  TextEditingController paymentAmountController = TextEditingController();
  TextEditingController paymentPayerNameController = TextEditingController();
  GlobalKey<FormState> paymentFormKey = GlobalKey<FormState>();

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

  Future<void> addPaymentData(
      {required BuildContext context,
      required String status,
      required String transactionId,
      required String occasionId,
      required String remainingPrince,
      required String occasionName,
      required double paymentAmount}) async {
    emit(PaymentAddLoadingState());

    double paymentCounterValue = double.parse(
        convertArabicToEnglishNumbers(paymentAmountController.text.toString()));

    await FirebaseFirestore.instance
        .collection("Occasions")
        .doc(occasionId)
        .update({
      "moneyGiftAmount": paymentAmount + paymentCounterValue,
    });

    await FirebaseFirestore.instance
        .collection("Occasions")
        .doc(occasionId)
        .collection("payments")
        .add({
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
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection("Occasions")
          .doc(occasionId)
          .collection("payments")
          .doc(value.id)
          .update({"paymentId": value.id});
      await FirebaseFirestore.instance
          .collection("payments")
          .doc(value.id)
          .set({
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
      }).then((value) {
        debugPrint("payment added to payments collection");
        emit(PaymentAddSuccessState());
      }).catchError((error) {
        debugPrint(
            "error when add payment to payments collection : ${error.toString()}");
        emit(PaymentAddErrorState());
      });
      paymentAmountController.clear();
      paymentPayerNameController.clear();
      paymentStatusList.clear();
      debugPrint("payment added");
      emit(PaymentAddSuccessState());
    }).catchError((error) {
      debugPrint("error when add payment : ${error.toString()}");
      emit(PaymentAddErrorState());
    });
  }

  void shareNames({required String occasionName, required List<String> names}) {
    String formattedNames = names.map((name) => "• $name").join('\n');
    Share.share(
        " قائمة الأسماء المشاركين ف هديتي $occasionName \n\n$formattedNames");
  }

  List<PaymentModel> occasionPaymentsList = [];

  Future<void> getOccasionPaymentsList({required String occasionId}) async {
    occasionPaymentsList = [];
    emit(PaymentGetLoadingState());
    await FirebaseFirestore.instance
        .collection("Occasions")
        .doc(occasionId)
        .collection("payments")
        .get()
        .then((value) async {
      for (var element in value.docs) {
        occasionPaymentsList.add(PaymentModel.fromMap(element.data()));
      }
      debugPrint("payments got==> ${occasionPaymentsList.length}");
      emit(PaymentGetSuccessState());
    }).catchError((error) {
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
      String formattedAmount = double.tryParse(
            convertArabicToEnglishNumbers(
                paymentAmountController.text.toString()),
          )?.toStringAsFixed(2) ??
          "0.00";
      debugPrint("Formatted Amount: $formattedAmount");

      if (double.parse(formattedAmount) <= 0) {
        emit(PaymentHyperPayErrorState());
        return {"error": "Amount must be greater than 0"};
      }

      final body = {
        "entityId": "8acda4ca96fcfe430197165a7a1c64df",
        "amount": formattedAmount,
        "currency": "SAR",
        "paymentType": "DB",
        "merchantTransactionId": merchantTransactionId,
        "customer.email": email.trim(),
        "customer.givenName": givenName.trim(),
        "customer.surname": surname.trim(),
        "billing.street1": street.trim(),
        "billing.city": city.trim(),
        "billing.state": state.trim(),
        "billing.country": "SA",
        "billing.postcode": postcode.trim(),
        "shopperResultUrl": "https://hadawi.netlify.app/payment-result",
      };

      debugPrint("HyperPay Live Request Body: ${jsonEncode(body)}");

      final response = await http.post(
        Uri.parse("https://eu-prod.oppwa.com/v1/checkouts"),
        headers: {
          "Authorization":
              "Bearer OGFjZGE0Y2E5NmZjZmU0MzAxOTcxNjVhMGE2YzY0ZDd8cWRuOVIzekxiWFFvY0JScks5Kzo=",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        debugPrint("Checkout ID response: $data");

        if (data.containsKey("id")) {
          emit(PaymentHyperPaySuccessState());
          return {
            "checkoutId": data["id"],
            "fullResponse": data,
          };
        } else {
          emit(PaymentHyperPayErrorState());
          return {
            "error": "Invalid response format",
            "fullResponse": data,
          };
        }
      } else {
        emit(PaymentHyperPayErrorState());
        return {
          "error": "HTTP Error ${response.statusCode}",
          "message": response.body,
        };
      }
    } catch (e) {
      emit(PaymentHyperPayErrorState());
      return {
        "error": "Exception",
        "message": e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getCheckoutIdApplePay({
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
      String formattedAmount = double.tryParse(convertArabicToEnglishNumbers(
                  paymentAmountController.text.toString()))
              ?.toStringAsFixed(2) ??
          "0.00";

      final response = await http.post(
        Uri.parse("https://eu-test.oppwa.com/v1/checkouts"),
        headers: {
          "Authorization":
              "Bearer OGFjN2E0Yzc5NWEwZjcyZjAxOTVhMzc1MjY1NjAzZjV8Sz9DcD9QeFV4PTVGUWJ1S2MlUHU=",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "entityId": "8ac7a4ca969f7e8d01969ff847030111",
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
          final result = {"checkoutId": data["id"], "fullResponse": data};

          emit(PaymentHyperPaySuccessState());
          return result;
        } else {
          debugPrint("Missing required fields in response: ${data.toString()}");
          emit(PaymentHyperPayErrorState());
          return {"error": "Invalid response format", "fullResponse": data};
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
      debugPrint(
          "Exception when getting HyperPay checkout ID: ${e.toString()}");
      emit(PaymentHyperPayErrorState());
      return {"error": "Exception", "message": e.toString()};
    }
  }

  List<Map<String, dynamic>> paymentStatusList = [];

  Future<Map<String, dynamic>> checkPaymentStatus(
      String checkoutId, BuildContext context) async {
    final response = await http.get(
      Uri.parse(
          "https://eu-prod.oppwa.com/v1/checkouts/$checkoutId/payment?entityId=8acda4ca96fcfe430197165a7a1c64df"),
      headers: {
        "Authorization":
            "Bearer OGFjZGE0Y2E5NmZjZmU0MzAxOTcxNjVhMGE2YzY0ZDd8cWRuOVIzekxiWFFvY0JScks5Kzo=",
      },
    );

    final data = jsonDecode(response.body);
    final resultCode = data['result']['code'];
    if (resultCode != "200.300.404") {
      paymentStatusList.add(data);
    }
    emit(PaymentHyperPaySuccessState());
    debugPrint("Payment Status Response: ${data.toString()}");

    return data;
  }

  Future<Map<String, dynamic>> checkApplePaymentStatus(
      String checkoutId, BuildContext context) async {
    final response = await http.get(
      Uri.parse(
          "https://eu-test.oppwa.com/v1/checkouts/$checkoutId/payment?entityId=8ac7a4ca969f7e8d01969ff847030111"),
      headers: {
        "Authorization":
            "Bearer OGFjN2E0Yzc5NWEwZjcyZjAxOTVhMzc1MjY1NjAzZjV8Sz9DcD9QeFV4PTVGUWJ1S2MlUHU=",
      },
    );

    final data = jsonDecode(response.body);
    final resultCode = data['result']['code'];
    if (resultCode != "200.300.404") {
      paymentStatusList.add(data);
    }
    emit(PaymentHyperPaySuccessState());
    debugPrint("Payment Status Response: ${data.toString()}");

    return data;
  }


  Future<void> loginAndCreateInvoice({
    required String amount,
    required String name,
    required String email,
    required String phone,
    required String personName,
    required String occasionType,
  }) async {
    final loginUrl = Uri.parse('https://hyperbill-sandbox.hyperpay.com/api/login');
    final invoiceUrl = Uri.parse('https://hyperbill-sandbox.hyperpay.com/api/simpleInvoice');

    emit(PaymentCreateLinkLoadingState());

    final loginBody = {
      "email": "mohamed.mmdouh.dev@gmail.com",
      "password": "Mmmmmmmm156**"
    };

    try {
      final loginResponse = await http.post(
        loginUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(loginBody),
      );

      final loginData = jsonDecode(loginResponse.body);
      if (loginData['status'] != true) {
        debugPrint("Login failed: ${loginData['message']}");
        return;
      }

      final accessToken = loginData['data']['accessToken'];
      debugPrint("Login successful. Access token: $accessToken");

      final invoiceBody = {
        "amount": amount,
        "vat": "0.00",
        "currency": "SAR",
        "payment_type": "DB",
        "name": name,
        "email": email,
        "phone": phone,
        "lang": "ar"
      };

      final invoiceResponse = await http.post(
        invoiceUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(invoiceBody),
      );

      final invoiceData = jsonDecode(invoiceResponse.body);
      String link = invoiceData['url'] ?? '';
      debugPrint("Invoice Response: ${jsonEncode(invoiceData)}");
      Share.share(
          'قام صديقك ${personName} بدعوتك للمشاركة في مناسبة له ${occasionType} للمساهمة بالدفع اضغط على الرابط ادناه لرؤية تفاصيل عن الهدية: $link');
      emit(PaymentCreateLinkSuccessState());

    } catch (e) {
      debugPrint("Error in creating payment link: $e");
      emit(PaymentCreateLinkErrorState());
    }
  }



}
