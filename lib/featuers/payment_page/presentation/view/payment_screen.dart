import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_cubit.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_states.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/apply_payment.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/payment_web_screen.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/loading_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PaymentScreen extends StatefulWidget {
  final OccasionEntity occasionEntity;
  const PaymentScreen({super.key, required this.occasionEntity});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod selectedPaymentMethod = PaymentMethod.mada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.gray,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Payment ${widget.occasionEntity.occasionType} (${widget.occasionEntity.personName})",
            style: TextStyles.textStyle18Bold
                .copyWith(color: ColorManager.primaryBlue),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image(image: AssetImage(AssetsManager.logoWithoutBackground)),
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
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.height * 0.02),
                child: Form(
                  key: PaymentCubit.get(context).paymentFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.height * 0.02),

                      // Payment progress bar
                      buildProgressIndicator(),
                      SizedBox(height: SizeConfig.height * 0.04),

                      // Amount field
                      buildAmountField(context),
                      SizedBox(height: SizeConfig.height * 0.02),

                      // Name field
                      buildNameField(context),
                      SizedBox(height: SizeConfig.height * 0.04),

                      // Payment Method Selection
                      buildPaymentMethodSection(context),
                      SizedBox(height: SizeConfig.height * 0.04),

                      // Payment button
                      buildPaymentButton(context),

                      SizedBox(height: SizeConfig.height * 0.04),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildProgressIndicator() {
    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManager.gray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: (double.parse(widget.occasionEntity.moneyGiftAmount.toString()) /
            double.parse(widget.occasionEntity.giftPrice.toString())),
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.primaryBlue,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buildAmountField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Amount",
          style: TextStyles.textStyle16Bold.copyWith(color: ColorManager.black),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DefaultTextField(
                controller: PaymentCubit.get(context).paymentAmountController,
                hintText: "Enter amount",
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Please enter an amount";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                fillColor: ColorManager.gray,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "SAR",
              style: TextStyles.textStyle16Regular,
            )
          ],
        ),
      ],
    );
  }

  Widget buildNameField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name",
          style: TextStyles.textStyle16Bold.copyWith(color: ColorManager.black),
        ),
        SizedBox(height: 8),
        DefaultTextField(
          controller: PaymentCubit.get(context).paymentPayerNameController,
          hintText: '',
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter your name";
            }
            return null;
          },
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          fillColor: ColorManager.gray,
        ),
      ],
    );
  }

  Widget buildPaymentMethodSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Method",
          style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
        ),
        Text(
          "Select one of the payment methods",
          style: TextStyles.textStyle16Regular.copyWith(color: Colors.grey),
        ),
        SizedBox(height: SizeConfig.height * 0.02),

        // Mada Option
        buildPaymentMethodTile(
          imagePath: 'assets/images/mada_pay.png',
          title: 'Mada',
          subtitle: "Pay with Mada card",
          value: PaymentMethod.mada,
        ),
        SizedBox(height: 10),

        // Visa Option
        buildPaymentMethodTile(
          imagePath: 'assets/images/visa_card.png',
          title: 'Visa',
          subtitle: "Pay with Visa card",
          value: PaymentMethod.visa,
        ),
        SizedBox(height: 10),

        // MasterCard Option
        buildPaymentMethodTile(
          imagePath: 'assets/images/mastercard.png',
          title: 'MasterCard',
          subtitle: "Pay with MasterCard",
          value: PaymentMethod.masterCard,
        ),
        SizedBox(height: 10),

        // STC Pay Option
        buildPaymentMethodTile(
          imagePath: 'assets/images/stc_pay.jpg',
          title: 'STC Pay',
          subtitle: "Pay with STC Pay",
          value: PaymentMethod.stcPay,
        ),
        SizedBox(height: 10),

        //Apple Pay Option
        Platform.isIOS? buildPaymentMethodTile(
          imagePath: AssetsManager.appleIcon,
          title: 'Apple Pay',
          subtitle: "Pay with Apple Pay",
          value: PaymentMethod.applePay,
          iconColor: Colors.black,
        ):SizedBox(),
      ],
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: ColorManager.gray.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedPaymentMethod == value
                ? ColorManager.primaryBlue
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
                    ? ColorManager.primaryBlue
                    : Colors.white,
                border: Border.all(
                  color: selectedPaymentMethod == value
                      ? ColorManager.primaryBlue
                      : Colors.grey,
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
            Image.asset(
              imagePath,
              height: 32,
              width: 32,
              color: iconColor,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.textStyle16Bold,
                  ),
                  Text(
                    subtitle,
                    style: TextStyles.textStyle16Regular.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentButton(BuildContext context) {
    return DefaultButton(
      buttonText: "Next",
      onPressed: () async {
        if (PaymentCubit.get(context).paymentFormKey.currentState!.validate()) {
          String merchantTransactionId = "ORDER-${DateTime.now().millisecondsSinceEpoch}";

          switch (selectedPaymentMethod) {
            case PaymentMethod.mada:
              final checkoutData = await PaymentCubit.get(context).getCheckoutId(
                email: UserDataFromStorage.emailFromStorage,
                givenName: UserDataFromStorage.userNameFromStorage,
                surname: UserDataFromStorage.userNameFromStorage,
                street: "street",
                city: "city",
                state: "state",
                postcode: "12345",
                merchantTransactionId: merchantTransactionId,
              );

              processPayment(context, checkoutData, merchantTransactionId, "MADA");
              break;

            case PaymentMethod.visa:
              final checkoutData = await PaymentCubit.get(context).getCheckoutId(
                email: UserDataFromStorage.emailFromStorage,
                givenName: UserDataFromStorage.userNameFromStorage,
                surname: UserDataFromStorage.userNameFromStorage,
                street: "street",
                city: "city",
                state: "state",
                postcode: "12345",
                merchantTransactionId: merchantTransactionId,
              );

              processPayment(context, checkoutData, merchantTransactionId, "VISA");
              break;

            case PaymentMethod.masterCard:
              final checkoutData = await PaymentCubit.get(context).getCheckoutId(
                email: UserDataFromStorage.emailFromStorage,
                givenName: UserDataFromStorage.userNameFromStorage,
                surname: UserDataFromStorage.userNameFromStorage,
                street: "street",
                city: "city",
                state: "state",
                postcode: "12345",
                merchantTransactionId: merchantTransactionId,
              );

              processPayment(context, checkoutData, merchantTransactionId, "MASTER");
              break;

            case PaymentMethod.stcPay:
              final checkoutData = await PaymentCubit.get(context).getCheckoutId(
                email: UserDataFromStorage.emailFromStorage,
                givenName: UserDataFromStorage.userNameFromStorage,
                surname: UserDataFromStorage.userNameFromStorage,
                street: "street",
                city: "city",
                state: "state",
                postcode: "12345",
                merchantTransactionId: merchantTransactionId,
              );

              processPayment(context, checkoutData, merchantTransactionId, "STC_PAY");
              break;

            case PaymentMethod.applePay:
              final checkoutData = await PaymentCubit.get(context).getCheckoutIdApplePay(
                  email: UserDataFromStorage.emailFromStorage,
                  givenName: UserDataFromStorage.userNameFromStorage,
                  surname: UserDataFromStorage.userNameFromStorage,
                  street: "street",
                  city: "city",
                  state: "state",
                  postcode: "12345",
                  merchantTransactionId: merchantTransactionId
              );

              customPushNavigator(
                  context,
                  ApplePayWebView(
                    checkoutId: checkoutData["checkoutId"],
                    integrity: checkoutData["integrity"],
                    paymentMethod: "APPLEPAY",
                    occasionId: widget.occasionEntity.occasionId,
                    occasionName: widget.occasionEntity.type,
                    transactionId: merchantTransactionId,
                    remainingPrice: double.parse(widget.occasionEntity.giftPrice.toString()) -
                        double.parse(widget.occasionEntity.moneyGiftAmount.toString()),
                    paymentAmount: double.parse(context.read<OccasionCubit>().convertArabicToEnglishNumbers(context.read<PaymentCubit>().paymentAmountController.text.toString())),
                  )
              );
              break;
          }
        }
      },
      buttonColor: ColorManager.primaryBlue,
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
          occasionName: widget.occasionEntity.occasionType,
          transactionId: merchantTransactionId,
          remainingPrice: double.parse(widget.occasionEntity.giftPrice.toString()) -
              double.parse(widget.occasionEntity.moneyGiftAmount.toString()),
          paymentAmount: double.parse(widget.occasionEntity.moneyGiftAmount.toString()),
          occasionEntity: widget.occasionEntity,
        )
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