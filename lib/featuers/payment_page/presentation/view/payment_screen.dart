import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_cubit.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_states.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/apply_payment.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/create_payment_link.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/payment_web_screen.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_details.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/loading_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pay/pay.dart';

class PaymentScreen extends StatefulWidget {
  final OccasionEntity occasionEntity;
  const PaymentScreen({super.key, required this.occasionEntity});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod selectedPaymentMethod = PaymentMethod.mada;
  static String applePayConfig = '''
{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.app.hadawiapp",
    "displayName": "Hadawi",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["visa", "masterCard", "amex"],
    "countryCode": "SA",
    "currencyCode": "SAR"
  }
}
''';
  @override
  void initState() {
    // TODO: implement initState
    context.read<PaymentCubit>().paymentAmountController = TextEditingController(
      text: widget.occasionEntity.amountForEveryone.toString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "${AppLocalizations.of(context)!.translate('payment').toString()} ${widget.occasionEntity.type}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8B7BA8),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF8B7BA8)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AssetsManager.logoWithoutBackground,
              height: 32,
            ),
          ),
        ],
      ),
      body: BlocBuilder<PaymentCubit, PaymentStates>(
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: (state is PaymentHyperPayLoadingState) ||
                (state is PaymentAddLoadingState) ||
                (state is ApplyPaymentLoadingState),
            progressIndicator: LoadingAnimationWidget(),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Progress Section with Amount Info
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate("goal").toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  '${widget.occasionEntity.giftPrice} ${AppLocalizations.of(context)!.translate("rsa").toString()}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate("collected").toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  '${widget.occasionEntity.moneyGiftAmount} ${AppLocalizations.of(context)!.translate("rsa").toString()}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              Container(
                                height: 12,
                                color: Color(0xFFF0EEF5),
                              ),
                              FractionallySizedBox(
                                widthFactor: (widget.occasionEntity.moneyGiftAmount / widget.occasionEntity.giftPrice).clamp(0.0, 1.0),
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF8B7BA8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${((widget.occasionEntity.moneyGiftAmount / widget.occasionEntity.giftPrice) * 100).toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8B7BA8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: PaymentCubit.get(context).paymentFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Amount field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate("amount").toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: PaymentCubit.get(context).paymentAmountController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xFFF0EEF5),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        ),
                                        enabled: false,
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return AppLocalizations.of(context)!.translate("amountValidate").toString();
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF0EEF5),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.translate("rsa").toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),

                          // Name field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate("fullName").toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 12),
                                TextFormField(
                                  controller: PaymentCubit.get(context).paymentPayerNameController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF0EEF5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return AppLocalizations.of(context)!.translate("fullNameHint").toString();
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),

                          // Payment Method Section
                          Text(
                            AppLocalizations.of(context)!.translate("paymentMethod").toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.translate("paymentMethodHint").toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 16),

                          // Payment Methods
                          buildPaymentMethodTile(
                            imagePath: 'assets/images/mada_pay.png',
                            title: 'Mada',
                            subtitle: AppLocalizations.of(context)!.translate("madaHint").toString(),
                            value: PaymentMethod.mada,
                          ),
                          SizedBox(height: 12),
                          buildPaymentMethodTile(
                            imagePath: 'assets/images/visa_card.png',
                            title: 'Visa',
                            subtitle: AppLocalizations.of(context)!.translate("visaHint").toString(),
                            value: PaymentMethod.visa,
                          ),
                          SizedBox(height: 12),
                          buildPaymentMethodTile(
                            imagePath: 'assets/images/mastercard.png',
                            title: 'MasterCard',
                            subtitle: AppLocalizations.of(context)!.translate("masterHint").toString(),
                            value: PaymentMethod.masterCard,
                          ),
                          SizedBox(height: 12),
                          buildPaymentMethodTile(
                            imagePath: 'assets/images/stc_pay.jpg',
                            title: 'STC Pay',
                            subtitle: AppLocalizations.of(context)!.translate("stcHint").toString(),
                            value: PaymentMethod.stcPay,
                          ),
                          SizedBox(height: 24),

                          // Apple Pay Button (if iOS)
                          if (Platform.isIOS) ...[
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ApplePayButton(
                                paymentItems: [
                                  PaymentItem(
                                    label: "Total",
                                    amount: double.tryParse(PaymentCubit.get(context).convertArabicToEnglishNumbers(
                                        PaymentCubit.get(context).paymentAmountController.text.toString()))
                                        ?.toStringAsFixed(2) ??
                                        "0.00",
                                    status: PaymentItemStatus.final_price,
                                  )
                                ],
                                style: ApplePayButtonStyle.black,
                                type: ApplePayButtonType.buy,
                                onPaymentResult: (result) async {
                                  final cubit = PaymentCubit.get(context);

                                  if (PaymentCubit.get(context).paymentFormKey.currentState!.validate()) {
                                    final merchantTransactionId = "ORDER${DateTime.now().millisecondsSinceEpoch}";
                                    final checkoutData = await cubit.getCheckoutIdApplePay(
                                      email: "nouralsaid09@gmail.com",
                                      givenName: "Nour",
                                      surname: "Elsaid",
                                      street: "King Fahd Rd",
                                      city: "Riyadh",
                                      state: "Riyadh",
                                      postcode: "12211",
                                      merchantTransactionId: merchantTransactionId,
                                    );

                                    final checkoutId = checkoutData['checkoutId'];
                                    final token = result['token'];

                                    await cubit.sendApplePayTokenToBackend(checkoutId, token);
                                    if(state is SendAppleTokenSuccessState){
                                      await cubit.checkApplePaymentStatus(checkoutId, context);
                                      handlePaymentResult(context.read<PaymentCubit>().paymentStatusList.last['result']['code'], context.read<PaymentCubit>().paymentStatusList.last['result']['description'], context.read<PaymentCubit>().paymentStatusList.last, merchantTransactionId);
                                    }else{
                                      showPaymentError(AppLocalizations.of(context)!.translate("applePayError").toString());
                                      return;
                                    }
                                  }
                                },
                                paymentConfiguration: PaymentConfiguration.fromJsonString(applePayConfig),
                              ),
                            ),
                            SizedBox(height: 24),
                          ],

                          // Next Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (PaymentCubit.get(context).paymentFormKey.currentState!.validate()) {
                                  String merchantTransactionId = "ORDER${DateTime.now().millisecondsSinceEpoch}";

                                  switch (selectedPaymentMethod) {
                                    case PaymentMethod.mada:
                                      final checkoutData = await PaymentCubit.get(context).getCheckoutId(
                                        email: "nouralsaid09@gmail.com",
                                        givenName: "Nour",
                                        surname: "Elsaid",
                                        street: "King Fahd Rd",
                                        city: "Riyadh",
                                        state: "Riyadh",
                                        postcode: "12211",
                                        merchantTransactionId: merchantTransactionId,
                                      );
                                      processPayment(context, checkoutData, merchantTransactionId, "MADA");
                                      break;
                                    case PaymentMethod.visa:
                                      final checkoutData = await PaymentCubit.get(context).getCheckoutId(
                                        email: "nouralsaid09@gmail.com",
                                        givenName: "Nour",
                                        surname: "Elsaid",
                                        street: "King Fahd Rd",
                                        city: "Riyadh",
                                        state: "Riyadh",
                                        postcode: "12211",
                                        merchantTransactionId: merchantTransactionId,
                                      );
                                      processPayment(context, checkoutData, merchantTransactionId, "VISA");
                                      break;
                                    case PaymentMethod.masterCard:
                                      final checkoutData = await PaymentCubit.get(context).getCheckoutId(
                                        email: "nouralsaid09@gmail.com",
                                        givenName: "Nour",
                                        surname: "Elsaid",
                                        street: "King Fahd Rd",
                                        city: "Riyadh",
                                        state: "Riyadh",
                                        postcode: "12211",
                                        merchantTransactionId: merchantTransactionId,
                                      );
                                      processPayment(context, checkoutData, merchantTransactionId, "MASTER");
                                      break;
                                    case PaymentMethod.stcPay:
                                      final checkoutData = await PaymentCubit.get(context).getCheckoutId(
                                        email: "nouralsaid09@gmail.com",
                                        givenName: "Nour",
                                        surname: "Elsaid",
                                        street: "King Fahd Rd",
                                        city: "Riyadh",
                                        state: "Riyadh",
                                        postcode: "12211",
                                        merchantTransactionId: merchantTransactionId,
                                      );
                                      processPayment(context, checkoutData, merchantTransactionId, "STC_PAY");
                                      break;
                                    case PaymentMethod.applePay:
                                      final checkoutData = await PaymentCubit.get(context).getCheckoutIdApplePay(
                                        email: "nouralsaid09@gmail.com",
                                        givenName: "Nour",
                                        surname: "Elsaid",
                                        street: "King Fahd Rd",
                                        city: "Riyadh",
                                        state: "Riyadh",
                                        postcode: "12211",
                                        merchantTransactionId: merchantTransactionId
                                      );
                                      customPushNavigator(
                                        context,
                                        ApplePayWebView(
                                          checkoutId: checkoutData["checkoutId"],
                                          // integrity: checkoutData["integrity"],
                                          paymentMethod: "APPLEPAY",
                                          occasionId: widget.occasionEntity.occasionId,
                                          occasionName: widget.occasionEntity.type,
                                          transactionId: merchantTransactionId,
                                          occasionEntity: widget.occasionEntity,
                                          remainingPrice: double.parse(widget.occasionEntity.giftPrice.toString()) -
                                              double.parse(widget.occasionEntity.moneyGiftAmount.toString()),
                                          paymentAmount: double.parse(context.read<OccasionCubit>().convertArabicToEnglishNumbers(context.read<PaymentCubit>().paymentAmountController.text.toString())),
                                        )
                                      );
                                      break;
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF8B7BA8),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.translate('next').toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildPaymentMethodTile({
    required String imagePath,
    required String title,
    required String subtitle,
    required PaymentMethod value,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedPaymentMethod == value
                ? Color(0xFF8B7BA8)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selectedPaymentMethod == value
                    ? Color(0xFF8B7BA8)
                    : Colors.white,
                border: Border.all(
                  color: selectedPaymentMethod == value
                      ? Color(0xFF8B7BA8)
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: selectedPaymentMethod == value
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                height: 32,
                width: 48,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void processPayment(BuildContext context, Map checkoutData, String merchantTransactionId, String paymentMethod) {
    customPushNavigator(
        context,
        PaymentWebScreen(
          checkoutId: checkoutData["checkoutId"],
          integrity: checkoutData["integrity"],
          paymentMethod: paymentMethod,
          occasionId: widget.occasionEntity.occasionId,
          occasionName: widget.occasionEntity.type,
          transactionId: merchantTransactionId,
          remainingPrice: double.parse(widget.occasionEntity.giftPrice.toString()) -
              double.parse(widget.occasionEntity.moneyGiftAmount.toString()),
          paymentAmount: double.parse(widget.occasionEntity.moneyGiftAmount.toString()),
          occasionEntity: widget.occasionEntity,
        )
    );
  }

  void handlePaymentResult(String resultCode, String description, Map<String, dynamic> fullData, String transactionId) {
    // Success codes typically start with 000.000., 000.100., or 000.200.
    if (resultCode.startsWith('000.000.') ||
        resultCode.startsWith('000.100.') ||
        resultCode.startsWith('000.200.')){
      debugPrint("✅ Payment Successful");
      showPaymentSuccess(description, transactionId);
    }
    // Pending codes typically start with 000.200.
    else if (resultCode.startsWith('000.200.')) {
      debugPrint("⏳ Payment Pending");
      showPaymentPending(description, transactionId);
    }
    // Failure codes can vary
    else {
      debugPrint("❌ Payment Failed: $resultCode - $description");
      showPaymentFailure(resultCode, description);
    }
  }

  void showPaymentSuccess(String description, String transactionId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('paymentSuccess').toString()),
        content: Text(AppLocalizations.of(context)!.translate('paymentSuccessMessage').toString()),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              customPushReplacement(context, OccasionDetails(occasionId: widget.occasionEntity.occasionId, fromHome: true,));
              await PaymentCubit.get(context).addPaymentData(
                context: context,
                transactionId: transactionId,
                occasionId: widget.occasionEntity.occasionId,
                remainingPrince: (double.parse(widget.occasionEntity.giftPrice.toString()) -
                    double.parse(widget.occasionEntity.moneyGiftAmount.toString())).toString(),
                paymentAmount: double.parse(widget.occasionEntity.moneyGiftAmount.toString()),
                status: "success",
                occasionName: widget.occasionEntity.type,
              );
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void showPaymentPending(String description, String transactionId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('paymentPending').toString()),
        content: Text("${AppLocalizations.of(context)!.translate('paymentPendingMessage').toString()}\n\n$description"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              customPushReplacement(context, OccasionDetails(occasionId: widget.occasionEntity.occasionId, fromHome: true,));
              await PaymentCubit.get(context).addPaymentData(
                context: context,
                transactionId: transactionId,
                occasionId: widget.occasionEntity.occasionId,
                remainingPrince: (double.parse(widget.occasionEntity.giftPrice.toString()) -
                    double.parse(widget.occasionEntity.moneyGiftAmount.toString())).toString(),
                paymentAmount: double.parse(widget.occasionEntity.moneyGiftAmount.toString()),
                status: "pending",
                occasionName: widget.occasionEntity.type,
              );
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void showPaymentFailure(String resultCode, String description) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('paymentFailed').toString()),
        content: Text("${AppLocalizations.of(context)!.translate('paymentFailedMessage').toString()}\n\n$description"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void showPaymentError(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Payment Error"),
        content: Text("An error occurred: $message"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}



// Enum for payment methods
enum PaymentMethod {
  mada,
  visa,
  masterCard,
  stcPay,
  applePay,
}