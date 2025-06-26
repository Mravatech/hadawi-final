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
            "${AppLocalizations.of(context)!.translate('payment').toString()} ${widget.occasionEntity.type} (${widget.occasionEntity.personName})",
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
                      SizedBox(height: SizeConfig.height * 0.02),

                      // Amount field
                      buildAmountField(context),
                      SizedBox(height: SizeConfig.height * 0.02),

                      // Name field
                      buildNameField(context),
                      SizedBox(height: SizeConfig.height * 0.02),

                      // Payment Method Selection
                      buildPaymentMethodSection(context),
                      SizedBox(height: SizeConfig.height * 0.04),

                      // Payment button
                      RawApplePayButton(
                        style: ApplePayButtonStyle.black, // or .white, .whiteOutline
                        type: ApplePayButtonType.buy, // or .donate, .book, .checkout etc.
                        onPressed: () async {
                          String merchantTransactionId = "ORDER${DateTime.now().millisecondsSinceEpoch}";
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
                                integrity: checkoutData["integrity"],
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
                        },
                        cornerRadius: 10,
                      ),
                      SizedBox(height: SizeConfig.height * 0.02),
                      buildPaymentButton(context),
                      // SizedBox(height: SizeConfig.height * 0.02),
                      // buildCreatePaymentLinkButton(context),

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
          AppLocalizations.of(context)!.translate("amount").toString(),
          style: TextStyles.textStyle16Bold.copyWith(color: ColorManager.black),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DefaultTextField(
                controller: PaymentCubit.get(context).paymentAmountController,
                hintText: "",
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return AppLocalizations.of(context)!.translate("amountValidate").toString();
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
              AppLocalizations.of(context)!.translate("rsa").toString(),
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
          AppLocalizations.of(context)!.translate("fullName").toString(),
          style: TextStyles.textStyle16Bold.copyWith(color: ColorManager.black),
        ),
        SizedBox(height: 8),
        DefaultTextField(
          controller: PaymentCubit.get(context).paymentPayerNameController,
          hintText: '',
          validator: (value) {
            if (value.isEmpty) {
              return AppLocalizations.of(context)!.translate("fullNameHint").toString();
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
          AppLocalizations.of(context)!.translate("paymentMethod").toString(),
          style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
        ),
        Text(
          AppLocalizations.of(context)!.translate("paymentMethodHint").toString(),
          style: TextStyles.textStyle16Regular.copyWith(color: Colors.grey),
        ),
        SizedBox(height: SizeConfig.height * 0.02),

        // Mada Option
        buildPaymentMethodTile(
          imagePath: 'assets/images/mada_pay.png',
          title: 'Mada',
          subtitle: AppLocalizations.of(context)!.translate("madaHint").toString(),
          value: PaymentMethod.mada,
        ),
        SizedBox(height: 10),

        // Visa Option
        buildPaymentMethodTile(
          imagePath: 'assets/images/visa_card.png',
          title: 'Visa',
          subtitle: AppLocalizations.of(context)!.translate("visaHint").toString(),
          value: PaymentMethod.visa,
        ),
        SizedBox(height: 10),

        // MasterCard Option
        buildPaymentMethodTile(
          imagePath: 'assets/images/mastercard.png',
          title: 'MasterCard',
          subtitle: AppLocalizations.of(context)!.translate("masterHint").toString(),
          value: PaymentMethod.masterCard,
        ),
        SizedBox(height: 10),

        // STC Pay Option
        buildPaymentMethodTile(
          imagePath: 'assets/images/stc_pay.jpg',
          title: 'STC Pay',
          subtitle: AppLocalizations.of(context)!.translate("stcHint").toString(),
          value: PaymentMethod.stcPay,
        ),
        // SizedBox(height: 10),

        //Apple Pay Option
        // Platform.isIOS? buildPaymentMethodTile(
        //   imagePath: AssetsManager.appleIcon,
        //   title: 'Apple Pay',
        //   subtitle: "Pay with Apple Pay",
        //   value: PaymentMethod.applePay,
        //   iconColor: Colors.black,
        // ):SizedBox(),
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
      buttonText: AppLocalizations.of(context)!.translate('next').toString(),
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
                    integrity: checkoutData["integrity"],
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
      buttonColor: ColorManager.primaryBlue,
    );
  }

  // Widget buildCreatePaymentLinkButton(BuildContext context) {
  //   return DefaultButton(
  //     buttonText: AppLocalizations.of(context)!.translate('createPaymentLink').toString(),
  //     onPressed: () async {
  //       customPushNavigator(context, CreatePaymentLinkScreen(
  //         occasionEntity: widget.occasionEntity,
  //       ));
  //     },
  //     buttonColor: ColorManager.primaryBlue,
  //   );
  // }

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
}

// Enum for payment methods
enum PaymentMethod {
  mada,
  visa,
  masterCard,
  stcPay,
  applePay,
}