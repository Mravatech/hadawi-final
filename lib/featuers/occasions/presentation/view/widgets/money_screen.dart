import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/occasion_summary.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/gift_delivery_screen.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/present_amount_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MoneyScreen extends StatelessWidget {
  const MoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionCubit, OccasionState>(
      listener: (context, state) {
        if (state is AddOccasionSuccessState) {
          customToast(
              title: AppLocalizations.of(context)!.translate('occasionAddedSuccessfully').toString(), color: ColorManager.success);
          Navigator.pop(context);
          UserDataFromStorage.removeDataFromStorage('giftName');
          UserDataFromStorage.removeDataFromStorage('giftLink');
          UserDataFromStorage.removeDataFromStorage('giftType');
          UserDataFromStorage.removeDataFromStorage('giftImage');
          UserDataFromStorage.removeDataFromStorage('giftBySharing');
          UserDataFromStorage.removeDataFromStorage('moneyGiftAmount');
          UserDataFromStorage.removeDataFromStorage('occasionName');
          UserDataFromStorage.removeDataFromStorage('occasionDate');
          UserDataFromStorage.removeDataFromStorage('occasionType');
        }
      },
      builder: (context, state) {
        final cubit = context.read<OccasionCubit>();
        final mediaQuery = MediaQuery.sizeOf(context);
        return ModalProgressHUD(
          inAsyncCall: state is AddOccasionLoadingState ||
              state is UploadImageLoadingState,
          child: Scaffold(
            backgroundColor: ColorManager.white,
            appBar: AppBar(
                backgroundColor: ColorManager.gray,
                title: Text(
                  AppLocalizations.of(context)!
                      .translate('money')
                      .toString(),
                  style: TextStyles.textStyle18Bold.copyWith(
                      color: ColorManager.black),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                        image: AssetImage(AssetsManager.logoWithoutBackground)),
                  ),

                ]),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: cubit.moneyFormKey,
                  child: Column(
                    crossAxisAlignment: CashHelper.languageKey == 'ar'
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      /// by sharing
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('public').toString()} ",
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          SizedBox(width: 10,),
                          Switch(
                              value: cubit.isPublicValue,
                              onChanged: (value) {
                                cubit.switchIsPublic();
                              }),
                          SizedBox(width: 10,),
                          Text(
                            AppLocalizations.of(context)!
                                .translate('private')
                                .toString(),
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),

                        ],
                      ),
                      SizedBox(height: mediaQuery.height * 0.02),

                      /// amount
                      Text(
                        "${AppLocalizations.of(context)!.translate('moneyAmount').toString()} ",
                        style: TextStyles.textStyle12Bold
                            .copyWith(color: ColorManager.black),
                      ),
                      SizedBox(height: mediaQuery.height * 0.01,),
                      Row(
                        children: [
                          Expanded(
                            child: DefaultTextField(
                                controller: cubit.moneyAmountController,
                                hintText: AppLocalizations.of(context)!
                                    .translate('moneyAmountHint')
                                    .toString(),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate('validateMoneyAmount')
                                        .toString();
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                fillColor: ColorManager.gray),
                          ),
                          SizedBox(width: 10,),
                          Text(
                            AppLocalizations.of(context)!.translate('rsa').toString(),
                            style: TextStyles.textStyle18Regular,
                          )
                        ],
                      ),
                      SizedBox(height: mediaQuery.height * 0.02),
                      Text(
                        "${AppLocalizations.of(context)!.translate('packaging').toString()}: ",
                        style: TextStyles.textStyle18Bold
                            .copyWith(color: ColorManager.black),
                      ),

                      SizedBox(height: mediaQuery.height * 0.01),
                      /// with packaging
                      Row(
                        children: [
                          /// with packaging
                          GestureDetector(
                            onTap: () {
                              cubit.switchGiftWithPackage(true);
                            },
                            child: Container(
                              height: mediaQuery.height * .055,
                              width: mediaQuery.height * .15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: cubit.giftWithPackage
                                    ? ColorManager.primaryBlue
                                    : ColorManager.gray,
                                borderRadius:
                                BorderRadius.circular(mediaQuery.height * 0.05),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('withPackaging')
                                    .toString(),
                                style: TextStyles.textStyle18Bold
                                    .copyWith(color: ColorManager.white),
                              ),
                            ),
                          ),
                          SizedBox(width: mediaQuery.width * .05),

                          /// without packaging
                          GestureDetector(
                            onTap: () {
                              cubit.switchGiftWithPackage(false);

                            },
                            child: Container(
                              height: mediaQuery.height * .055,
                              width: mediaQuery.height * .15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: cubit.giftWithPackage
                                    ? ColorManager.gray
                                    : ColorManager.primaryBlue,
                                borderRadius:
                                BorderRadius.circular(mediaQuery.height * 0.05),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('withoutPackaging')
                                    .toString(),
                                style: TextStyles.textStyle18Bold
                                    .copyWith(color: ColorManager.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: mediaQuery.height * 0.02),

                      /// receiver name
                      Visibility(
                        visible: cubit.giftWithPackage== false? true : false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translate('moneyReceiverName').toString(),
                              style: TextStyles.textStyle18Bold
                                  .copyWith(color: ColorManager.black),
                            ),
                            SizedBox(height: mediaQuery.height * 0.01),
                            DefaultTextField(
                                controller: cubit.giftReceiverNameController,
                                hintText: AppLocalizations.of(context)!.translate('moneyReceiverNameHint').toString(),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!.translate('validateMoneyReceiverName').toString();
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                fillColor: ColorManager.gray),
                            SizedBox(height: mediaQuery.height * 0.02),
                            /// receiver number
                            Text(
                              AppLocalizations.of(context)!.translate('moneyReceiverPhone').toString(),
                              style: TextStyles.textStyle18Bold
                                  .copyWith(color: ColorManager.black),
                            ),
                            SizedBox(height: mediaQuery.height * 0.01),
                            DefaultTextField(
                                controller: cubit.giftReceiverNumberController,
                                hintText: AppLocalizations.of(context)!.translate('moneyReceiverPhoneHint').toString(),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!.translate('validateMoneyReceiverPhone').toString();
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                fillColor: ColorManager.gray),
                            SizedBox(height: mediaQuery.height * 0.02),
                            /// bank name
                            Text(
                              AppLocalizations.of(context)!.translate('bankName').toString(),
                              style: TextStyles.textStyle18Bold
                                  .copyWith(color: ColorManager.black),
                            ),
                            SizedBox(height: mediaQuery.height * 0.01),
                            DefaultTextField(
                                controller: cubit.bankNameController,
                                hintText: AppLocalizations.of(context)!.translate('bankNameHint').toString(),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!.translate('validateBankName').toString();
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                fillColor: ColorManager.gray),
                            SizedBox(height: mediaQuery.height * 0.02),
                            /// account iban number
                            Text(
                              AppLocalizations.of(context)!.translate('ibanNumber').toString(),
                              style: TextStyles.textStyle18Bold
                                  .copyWith(color: ColorManager.black),
                            ),
                            SizedBox(height: mediaQuery.height * 0.01),
                            DefaultTextField(
                                controller: cubit.ibanNumberController,
                                hintText: AppLocalizations.of(context)!.translate('ibanNumberHint').toString(),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!.translate('validateIbanNumber').toString();
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                fillColor: ColorManager.gray),
                            SizedBox(height: mediaQuery.height * 0.02),

                            /// date of receive
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('receivingTime')
                                  .toString(),
                              style: TextStyles.textStyle18Bold
                                  .copyWith(color: ColorManager.black),
                            ),
                            SizedBox(height: mediaQuery.height * 0.01),
                            GestureDetector(
                              onTap: () {
                                showDatePicker(
                                  helpText: AppLocalizations.of(context)!
                                      .translate('receivingTime')
                                      .toString(),
                                  context: context,
                                  firstDate: DateTime(1920),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                ).then(
                                        (value) => cubit.setMoneyReceiveDate(brithDateValue: value!));
                              },
                              child: DefaultTextField(
                                  controller: cubit.moneyReceiveDateController,
                                  hintText: cubit.moneyReceiveDateController.text.isEmpty
                                      ? AppLocalizations.of(context)!
                                      .translate('receivingTimeHint')
                                      .toString()
                                      : cubit.occasionDateController.text,
                                  validator: (value) {
                                    if (value!.trim().isNotEmpty) return null;
                                    return AppLocalizations.of(context)!
                                        .translate('validateReceivingTime')
                                        .toString();
                                  },
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  enable: false,
                                  fillColor: ColorManager.gray),
                            ),

                            SizedBox(height: mediaQuery.height * 0.02),
                            Row(
                              mainAxisAlignment: CashHelper.languageKey == 'ar'
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.translate('isContainsNames').toString()} ",
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.black),
                                ),
                                Switch(
                                    value: cubit.giftContainsNameValue,
                                    onChanged: (value) {
                                      cubit.switchGiftContainsName();
                                    }),

                              ],
                            ),
                            SizedBox(height: mediaQuery.height * 0.02),


                            /// message
                            Text(
                              AppLocalizations.of(context)!.translate('giftCard').toString(),
                              style: TextStyles.textStyle18Bold
                                  .copyWith(color: ColorManager.black),
                            ),
                            SizedBox(height: mediaQuery.height * 0.01),
                            DefaultTextField(
                                controller: cubit.moneyGiftMessageController,
                                maxLines: 8,
                                hintText: AppLocalizations.of(context)!.translate('giftCardHint').toString(),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!.translate('validateGiftCard').toString();
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                fillColor: ColorManager.gray),
                            SizedBox(height: mediaQuery.height * 0.01),
                            /// note for send money fess
                            Text(
                              AppLocalizations.of(context)!.translate('moneyGiftFeesNote').toString(),
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.black),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: mediaQuery.height * 0.05),
                      /// continue
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            if(cubit.giftWithPackage == true){
                              customPushNavigator(context, GiftDeliveryScreen());
                            }else{
                              customPushNavigator(context, OccasionSummary());
                            }
                            // if (cubit.giftPrice == 0) {
                            //   customToast(
                            //       title: AppLocalizations.of(context)!
                            //           .translate('validateMoneyAmount')
                            //           .toString(),
                            //       color: ColorManager.error);
                            // } else {
                            //   cubit.addOccasion();
                            // }
                          },
                          child: Container(
                            height: mediaQuery.height * .055,
                            width: mediaQuery.width * .4,
                            decoration: BoxDecoration(
                              color: ColorManager.primaryBlue,
                              borderRadius: BorderRadius.circular(
                                  mediaQuery.height * 0.05),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('continue')
                                      .toString(),
                                  style: TextStyles.textStyle18Bold
                                      .copyWith(color: ColorManager.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: mediaQuery.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
