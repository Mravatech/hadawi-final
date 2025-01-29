import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/gift_screen.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/money_screen.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/toast.dart';

import '../../../../../utiles/cashe_helper/cashe_helper.dart';
import '../../../../../utiles/localiztion/app_localization.dart';

class ForOtherBody extends StatelessWidget {
  const ForOtherBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionCubit, OccasionState>(
      listener: (context, state) {
        if (state is AddOccasionSuccessState) {
          customToast(title: AppLocalizations.of(context)!.translate('occasionAddedSuccessfully').toString(), color: ColorManager.success);
        }
      },
      builder: (context, state) {
        final cubit = context.read<OccasionCubit>();
        final mediaQuery = MediaQuery.sizeOf(context);
        return Form(
          key: cubit.forOtherFormKey,
          child: Column(
            crossAxisAlignment: CashHelper.languageKey == 'ar'
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              /// person name
              Text(
                AppLocalizations.of(context)!.translate('personName').toString(),
                style: TextStyles.textStyle18Bold
                    .copyWith(color: ColorManager.black),
              ),
              SizedBox(height: mediaQuery.height * 0.01),

              DefaultTextField(
                  controller: cubit.nameController,
                  hintText: AppLocalizations.of(context)!.translate('personNameHint').toString(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.translate('validatePersonName').toString();
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  fillColor: ColorManager.gray),
              SizedBox(height: mediaQuery.height * 0.03),

              /// occasion
              Text(
                AppLocalizations.of(context)!.translate('occasionName').toString(),
                style: TextStyles.textStyle18Bold
                    .copyWith(color: ColorManager.black),
              ),
              SizedBox(height: mediaQuery.height * 0.01),

              DefaultTextField(
                  controller: cubit.occasionNameController,
                  hintText: AppLocalizations.of(context)!.translate('occasionNameHint').toString(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.translate('validateOccasionName').toString();
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  fillColor: ColorManager.gray),
              SizedBox(height: mediaQuery.height * 0.03),

              /// date of occasion
              Text(
                AppLocalizations.of(context)!.translate('occasionDate').toString(),
                style: TextStyles.textStyle18Bold
                    .copyWith(color: ColorManager.black),
              ),
              SizedBox(height: mediaQuery.height * 0.01),

              GestureDetector(
                onTap: () {
                  showDatePicker(
                    helpText: 'Select the date of the occasion',
                    context: context,
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  ).then((value) =>
                      cubit.setOccasionDate(brithDateValue: value!));
                },
                child: DefaultTextField(
                    controller: cubit.occasionDateController,
                    hintText: cubit.occasionDateController.text.isEmpty
                        ? AppLocalizations.of(context)!.translate('occasionDateHint').toString()
                        : cubit.occasionDateController.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.translate('validateOccasionDate').toString();
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    enable: false,
                    fillColor: ColorManager.gray),
              ),
              SizedBox(height: mediaQuery.height * 0.03),

              /// requested gift
              Row(
                mainAxisAlignment: CashHelper.languageKey == 'ar'
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.translate('giftType').toString()}: ",
                        style: TextStyles.textStyle18Bold
                            .copyWith(color: ColorManager.black),
                      ),

                      /// present
                      GestureDetector(
                        onTap: () {
                          cubit.giftType = 'هدية';
                          UserDataFromStorage.giftType = cubit.giftType;
                          cubit.switchGiftType();
                          debugPrint('giftType: ${cubit.giftType}');
                        },
                        child: Container(
                          height: mediaQuery.height * .055,
                          width: mediaQuery.width * .25,
                          decoration: BoxDecoration(
                            color: cubit.isPresent
                                ? ColorManager.primaryBlue
                                : ColorManager.gray,
                            borderRadius:
                            BorderRadius.circular(mediaQuery.height * 0.05),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('gift')
                                      .toString(),
                                  style: TextStyles.textStyle18Bold
                                      .copyWith(color: ColorManager.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: mediaQuery.width * .05),

                      /// money
                      GestureDetector(
                        onTap: () {
                          cubit.giftType = 'مبلغ مالي';
                          UserDataFromStorage.giftType = cubit.giftType;
                          cubit.switchGiftType();
                          debugPrint('giftType: ${cubit.giftType}');
                        },
                        child: Container(
                          height: mediaQuery.height * .055,
                          width: mediaQuery.width * .25,
                          decoration: BoxDecoration(
                            color: cubit.isMoney
                                ? ColorManager.primaryBlue
                                : ColorManager.gray,
                            borderRadius:
                            BorderRadius.circular(mediaQuery.height * 0.05),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('money')
                                      .toString(),
                                  style: TextStyles.textStyle18Bold
                                      .copyWith(color: ColorManager.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: mediaQuery.height * .02),
              /// service fees text
              Text(
                AppLocalizations.of(context)!.translate('feesNote').toString(),
                style: TextStyles.textStyle18Bold
                    .copyWith(color: ColorManager.black.withOpacity(.5)),
              ),
              SizedBox(height: mediaQuery.height * 0.02),
              ///  continue button
              state is AddOccasionLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                    child: GestureDetector(
                        onTap: () {
                          if (cubit.forOtherFormKey.currentState!.validate()) {
                            if (cubit.isPresent) {
                              customPushNavigator(
                                  context,
                                  BlocProvider<OccasionCubit>(
                                    create: (context) => OccasionCubit(),
                                    child: GiftScreen(),
                                  ));
                            } else {
                              customPushNavigator(
                                  context,
                                  BlocProvider<OccasionCubit>(
                                    create: (context) => OccasionCubit(),
                                    child: MoneyScreen(),
                                  ));
                            }
                          }
                          UserDataFromStorage.occasionName =
                              cubit.occasionNameController.text;
                          UserDataFromStorage.occasionDate =
                              cubit.occasionDateController.text;
                        },
                        child: Container(
                          height: mediaQuery.height * .06,
                          width: mediaQuery.width * .5,
                          decoration: BoxDecoration(
                            color: ColorManager.primaryBlue,
                            borderRadius:
                                BorderRadius.circular(mediaQuery.height * 0.05),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.translate('continue').toString(),
                                style: TextStyles.textStyle18Bold
                                    .copyWith(color: ColorManager.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                  )
            ],
          ),
        );
      },
    );
  }
}
