import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/occasion_summary.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/present_amount_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class GiftDeliveryScreen extends StatelessWidget {
  const GiftDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionCubit, OccasionState>(
        listener: (context, state) {},
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
                        .translate('receiveData')
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
                    key: cubit.deliveryFormKey,
                    child: Column(
                      crossAxisAlignment: CashHelper.languageKey == 'ar'
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        /// receiver name
                        Text(
                          AppLocalizations.of(context)!.translate('City').toString(),
                          style: TextStyles.textStyle18Bold
                              .copyWith(color: ColorManager.black),
                        ),
                        SizedBox(height: mediaQuery.height * 0.01),
                        DefaultTextField(
                            controller: cubit.giftDeliveryCityController,
                            hintText: AppLocalizations.of(context)!.translate('CityHint').toString(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!.translate('validateCity').toString();
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            fillColor: ColorManager.gray),
                        /// receiver name
                        Text(
                          AppLocalizations.of(context)!.translate('theDistrict').toString(),
                          style: TextStyles.textStyle18Bold
                              .copyWith(color: ColorManager.black),
                        ),
                        SizedBox(height: mediaQuery.height * 0.01),
                        DefaultTextField(
                            controller: cubit.giftDeliveryStreetController,
                            hintText: AppLocalizations.of(context)!.translate('theDistrictHint').toString(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!.translate('validateTheDistrict').toString();
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

                        SizedBox(height: mediaQuery.height * 0.02),

                        /// note
                        Text(
                          AppLocalizations.of(context)!.translate('note').toString(),
                          style: TextStyles.textStyle18Bold
                              .copyWith(color: ColorManager.black),
                        ),
                        SizedBox(height: mediaQuery.height * 0.01),
                        DefaultTextField(
                            controller: cubit.giftDeliveryNoteController,
                            maxLines: 8,
                            hintText: AppLocalizations.of(context)!.translate('noteHint').toString(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!.translate('validateNote').toString();
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            fillColor: ColorManager.gray),

                        SizedBox(height: mediaQuery.height * 0.05),
                        /// share and save
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              customPushNavigator(context, OccasionSummary());
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
