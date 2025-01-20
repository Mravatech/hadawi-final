import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/gift_screen.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/money_screen.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';

class ForMeBody extends StatelessWidget {
  const ForMeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OccasionCubit, OccasionState>(
      builder: (context, state) {
        final cubit = context.read<OccasionCubit>();
        final mediaQuery = MediaQuery.sizeOf(context);
        return Column(
          children: [
            /// old occasions
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ' :اضافة لمناسبة مسجلة سابقاً',
                  style: TextStyles.textStyle18Bold
                      .copyWith(color: ColorManager.black),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: mediaQuery.height * .06,
                    decoration: BoxDecoration(
                      color: ColorManager.gray,
                      borderRadius:
                      BorderRadius.circular(mediaQuery.height * 0.01),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size:  mediaQuery.height * 0.045,
                            color: ColorManager.primaryBlue,
                          ),

                          Text(
                            '',
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: mediaQuery.height * 0.03),

            /// new occasion
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ' :المناسبة جديدة',
                  style: TextStyles.textStyle18Bold
                      .copyWith(color: ColorManager.black),
                ),
                DefaultTextField(
                    controller: cubit.newOccasionNameController,
                    hintText: '',
                    validator: (value) {
                      return '';
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
                      helpText: 'تاريخ المناسبة',
                      context: context,
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    ).then((value) =>cubit.setOccasionDate(brithDateValue: value!));
                  },
                  child: DefaultTextField(
                      controller: cubit.occasionDateController,
                      hintText: cubit.occasionDateController.text.isEmpty
                          ? ''
                          : cubit.occasionDateController.text,
                      validator: (value) {
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      enable: false,
                      fillColor: ColorManager.gray),
                )
              ],
            ),
            SizedBox(height: mediaQuery.height * 0.03),
            /// money gift
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ' :المبلغ المطلوب',
                  style: TextStyles.textStyle18Bold
                      .copyWith(color: ColorManager.black),
                ),
                DefaultTextField(
                    controller: cubit.moneyAmountController,
                    hintText: '',
                    validator: (value) {
                      return '';
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorManager.gray)
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
                        customPushNavigator(
                            context,
                            BlocProvider<OccasionCubit>(
                              create: (context) => OccasionCubit(),
                              child: GiftScreen(),
                            ));
                        cubit.switchGiftKind();
                      },
                      child: Container(
                        height: mediaQuery.height * .055,
                        width: mediaQuery.width * .25,
                        decoration: BoxDecoration(
                          color: ColorManager.primaryBlue,
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
                      onTap: () {},
                      child: Container(
                        height: mediaQuery.height * .055,
                        width: mediaQuery.width * .25,
                        decoration: BoxDecoration(
                          color: ColorManager.primaryBlue,
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
            SizedBox(height: mediaQuery.height * 0.02),

            /// service fees text
            RichText(
                text: TextSpan(
                    text: 'علماً انه سيتم حسب رسوم استخدام التطبيق',
                    style: TextStyles.textStyle18Bold
                        .copyWith(color: ColorManager.black.withOpacity(.5)),
                    children: [
                  TextSpan(
                    text: ' ٪٥ ',
                    style: TextStyles.textStyle18Bold
                        .copyWith(color: ColorManager.primaryBlue),
                  )
                ])),
            SizedBox(height: mediaQuery.height * 0.02),

            ///  continue button
            GestureDetector(
              onTap: () {},
              child: Container(
                height: mediaQuery.height * .06,
                width: mediaQuery.width * .5,
                decoration: BoxDecoration(
                  color: ColorManager.primaryBlue,
                  borderRadius: BorderRadius.circular(mediaQuery.height * 0.05),
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
        );
      },
    );
  }
}
