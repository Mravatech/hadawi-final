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

class ForOtherBody extends StatelessWidget {
  const ForOtherBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionCubit, OccasionState>(
      listener: (context, state) {
        if (state is AddOccasionSuccessState) {
          customToast(title: 'تمت إضافة المناسبة', color: ColorManager.success);
        }
      },
      builder: (context, state) {
        final cubit = context.read<OccasionCubit>();
        final mediaQuery = MediaQuery.sizeOf(context);
        return Form(
          key: cubit.forOtherFormKey,
          child: Column(
            children: [
              /// person name
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ' :اسم الشخص',
                    style: TextStyles.textStyle18Bold
                        .copyWith(color: ColorManager.black),
                  ),
                  DefaultTextField(
                      controller: cubit.nameController,
                      hintText: '',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'رجاء ادخال اسم الشخص';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      fillColor: ColorManager.gray)
                ],
              ),
              SizedBox(height: mediaQuery.height * 0.03),

              /// occasion
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ' :المناسبة',
                    style: TextStyles.textStyle18Bold
                        .copyWith(color: ColorManager.black),
                  ),
                  DefaultTextField(
                      controller: cubit.occasionNameController,
                      hintText: '',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'رجاء ادخال اسم المناسبة';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      fillColor: ColorManager.gray)
                ],
              ),
              SizedBox(height: mediaQuery.height * 0.03),

              /// date of occasion
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ':تاريخ المناسبة',
                    style: TextStyles.textStyle18Bold
                        .copyWith(color: ColorManager.black),
                  ),
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
                            ? ''
                            : cubit.occasionDateController.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'رجاء ادخال تاريخ المناسبة';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        enable: false,
                        fillColor: ColorManager.gray),
                  )
                ],
              ),
              SizedBox(height: mediaQuery.height * 0.03),

              /// requested gift
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
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
                                  'هدية',
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
                          cubit.switchGiftType();
                          cubit.giftType = 'مبلغ مالي';
                          UserDataFromStorage.giftType = cubit.giftType;
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
                                  'مبلغ مالي',
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
                  Text(
                    ' :الهدية المطلوبة',
                    style: TextStyles.textStyle18Bold
                        .copyWith(color: ColorManager.black),
                  ),
                ],
              ),
              SizedBox(height: mediaQuery.height * .04),

              ///  continue button
              state is AddOccasionLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GestureDetector(
                      onTap: () {
                        if (cubit.forOtherFormKey.currentState!.validate()) {
                          if (cubit.giftType == 'هدية') {
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
                              'المتابعة',
                              style: TextStyles.textStyle18Bold
                                  .copyWith(color: ColorManager.white),
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
