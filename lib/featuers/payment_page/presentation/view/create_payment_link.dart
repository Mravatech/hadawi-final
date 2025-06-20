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
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/loading_widget.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PaymentScreen extends StatefulWidget {
  final OccasionEntity occasionEntity;
  const PaymentScreen({super.key, required this.occasionEntity});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController paymentAmountController = TextEditingController();
  TextEditingController paymentNameController = TextEditingController();
  TextEditingController paymentEmailController = TextEditingController();
  TextEditingController paymentPhoneController = TextEditingController();
  GlobalKey<FormState> paymentFormKey = GlobalKey<FormState>();


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
      body: BlocConsumer<PaymentCubit, PaymentStates>(
        listener: (context,state){
          if (state is PaymentCreateLinkSuccessState){
            customToast(title: AppLocalizations.of(context)!.translate('successPaymentLink').toString(), color: ColorManager.success);
            Navigator.pop(context);
          }
          if(state is PaymentCreateLinkErrorState){
            customToast(title: AppLocalizations.of(context)!.translate('errorPaymentLink').toString(), color: ColorManager.error);
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is PaymentCreateLinkLoadingState? true : false,
            progressIndicator: LoadingAnimationWidget(),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.height * 0.02),
                child: Form(
                  key: paymentFormKey,
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

                      buildPhoneField(context),
                      SizedBox(height: SizeConfig.height * 0.02),

                      buildEmailField(context),
                      SizedBox(height: SizeConfig.height * 0.02),


                      // Payment button
                      DefaultButton(
                        onPressed: () {
                          if (paymentFormKey
                              .currentState!
                              .validate()) {
                            PaymentCubit.get(context).loginAndCreateInvoice(
                              amount:paymentAmountController.text,
                              name:"${paymentNameController.text} - ${widget.occasionEntity.occasionType} (${widget.occasionEntity.personName}) - ${widget.occasionEntity.occasionId}",
                              email:paymentEmailController.text,
                              phone:paymentPhoneController.text,
                              personName: widget.occasionEntity.personName,
                              occasionType: widget.occasionEntity.occasionType,
                            );
                          }
                        },
                        buttonText: AppLocalizations.of(context)!
                          .translate("createPaymentLink")
                          .toString(),
                        buttonColor: ColorManager.primaryBlue,
                      ),


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
                controller: paymentAmountController,
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
          controller: paymentNameController,
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

  Widget buildEmailField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("email").toString(),
          style: TextStyles.textStyle16Bold.copyWith(color: ColorManager.black),
        ),
        SizedBox(height: 8),
        DefaultTextField(
          controller: paymentEmailController,
          hintText: '',
          validator: (value) {
            if (value.isEmpty) {
              return AppLocalizations.of(context)!.translate("emailHint").toString();
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          fillColor: ColorManager.gray,
        ),
      ],
    );
  }

  Widget buildPhoneField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("phone").toString(),
          style: TextStyles.textStyle16Bold.copyWith(color: ColorManager.black),
        ),
        SizedBox(height: 8),
        DefaultTextField(
          controller: paymentPhoneController,
          hintText: '',
          validator: (value) {
            if (value.isEmpty || !RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value) || value.length < 10 || value.length > 10) {
              return AppLocalizations.of(context)!.translate("validatePhone2").toString();
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          fillColor: ColorManager.gray,
        ),
      ],
    );
  }


}