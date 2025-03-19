import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_cubit.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_states.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/payment_web_screen.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/widgets/counter_widget.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/widgets/progress_indicator_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_button_with_image.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/loading_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PaymentScreen extends StatelessWidget {
  final OccasionEntity occasionEntity;
  const PaymentScreen({super.key, required this.occasionEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
          backgroundColor: ColorManager.gray,
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "${AppLocalizations.of(context)!.translate("payment").toString()} ${occasionEntity.occasionName} (${occasionEntity.personName})",
              style: TextStyles.textStyle18Bold
                  .copyWith(color: ColorManager.primaryBlue),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child:
                  Image(image: AssetImage(AssetsManager.logoWithoutBackground)),
            ),
          ]),
      body: BlocBuilder<PaymentCubit, PaymentStates>(
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is PaymentHyperPayLoadingState || state is PaymentAddLoadingState ? true : false,
            progressIndicator: LoadingAnimationWidget(),

            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.height * 0.02),
                child: Form(
                  key: PaymentCubit.get(context).paymentFormKey,
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.height * 0.02),

                      /// payment progress
                      ProgressIndicatorWidget(
                          value: (double.parse(
                                  occasionEntity.moneyGiftAmount.toString()) /
                              double.parse(occasionEntity.giftPrice.toString()))),
                      SizedBox(height: SizeConfig.height * 0.04),

                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('amount')} : ",
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: DefaultTextField(
                                controller: PaymentCubit.get(context)
                                    .paymentAmountController,
                                hintText: AppLocalizations.of(context)!
                                    .translate('amountMessage')
                                    .toString(),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate('amountValidate')
                                        .toString();
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                fillColor: ColorManager.gray),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .translate('rsa')
                                .toString(),
                            style: TextStyles.textStyle18Regular,
                          )
                        ],
                      ),

                      SizedBox(height: SizeConfig.height * 0.01),

                      /// payment name
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${AppLocalizations.of(context)!.translate("name")} : ",
                              style: TextStyles.textStyle18Bold.copyWith(
                                color: ColorManager.black,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: DefaultTextField(
                              controller: PaymentCubit.get(context).paymentPayerNameController,
                              hintText: '',
                              validator: (value) {
                                if (value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .translate('nameHint')
                                      .toString();
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              fillColor: ColorManager.gray,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: SizeConfig.height * 0.08),

                      // /// payment with apple
                      // DefaultButtonWithImage(
                      //   buttonText: "Apple Pay",
                      //   image: AssetsManager.appleIcon,
                      // ),

                      DefaultButton(
                        buttonText: AppLocalizations.of(context)!
                            .translate('payment')
                            .toString(),
                        onPressed: () async {
                          if(PaymentCubit.get(context).paymentFormKey.currentState!.validate()){

                            String merchantTransactionId = "ORDER-${DateTime.now().millisecondsSinceEpoch}";
                            final checkoutData = await PaymentCubit.get(context).getCheckoutId(
                                email: UserDataFromStorage.emailFromStorage,
                                givenName: UserDataFromStorage.userNameFromStorage,
                                surname: UserDataFromStorage.userNameFromStorage,
                                street: "street",
                                city: "city",
                                state: "state",
                                postcode: "12345",
                                merchantTransactionId: merchantTransactionId
                            );
                            // await PaymentCubit.get(context).checkPaymentStatus(checkoutData["checkoutId"],context);
                            customPushNavigator(
                                context,
                                PaymentWebScreen(
                                  checkoutId: checkoutData["checkoutId"],
                                  integrity: checkoutData["integrity"],
                                  occasionId: occasionEntity.occasionId,
                                  occasionName: occasionEntity.occasionName,
                                  paymentAmount: double.parse(
                                      occasionEntity.moneyGiftAmount.toString()),

                                ));
                          }
                        },
                        buttonColor: ColorManager.primaryBlue,
                      ),

                      // SizedBox(height: SizeConfig.height * 0.01),
                      //
                      // DefaultButton(
                      //   buttonText: AppLocalizations.of(context)!
                      //       .translate('payment')
                      //       .toString(),
                      //   onPressed: () async {
                      //     await PaymentCubit.get(context).addPaymentData(
                      //       context: context,
                      //       occasionId: occasionEntity.occasionId,
                      //       occasionName: occasionEntity.occasionName,
                      //       paymentAmount: double.parse(
                      //           occasionEntity.moneyGiftAmount.toString()),
                      //     );
                      //   },
                      //   buttonColor: ColorManager.primaryBlue,
                      // ),
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
}
