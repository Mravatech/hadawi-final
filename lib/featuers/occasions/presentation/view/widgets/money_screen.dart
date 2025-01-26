import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/present_amount_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MoneyScreen extends StatelessWidget {
  const MoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionCubit, OccasionState>(
      listener: (context, state) {
        if(state is AddOccasionSuccessState){
          customToast(title: " تمت اضافة المناسبة", color: ColorManager.success);
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
          inAsyncCall: state is AddOccasionLoadingState || state is UploadImageLoadingState,
          child: Scaffold(
            backgroundColor: ColorManager.white,
            appBar: AppBar(
                backgroundColor: ColorManager.gray,
                leadingWidth: mediaQuery.width * 0.3,
                leading: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: ColorManager.primaryBlue,
                        )),
                    Image(image: AssetImage(AssetsManager.logoWithoutBackground)),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "مبلغ مالي",
                      style: TextStyles.textStyle18Bold.copyWith(
                          color: ColorManager.black.withValues(
                        alpha: 0.4,
                      )),
                    ),
                  )
                ]),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.moneyFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// by sharing
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Switch(
                              value: cubit.bySharingValue,
                              onChanged: (value) {
                                cubit.switchBySharing();
                              }),
                          Text(
                            ' :مشاركة',
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),
                        ],
                      ),
                      SizedBox(height: mediaQuery.height * 0.03),
                      /// amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PresentAmountWidget(),
                          Text(
                            ' :المبلغ',
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),
                        ],
                      ),
                      SizedBox(height: mediaQuery.height * 0.03),
                      // /// bank name
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     Text(
                      //       ' :اسم البنك',
                      //       style: TextStyles.textStyle18Bold
                      //           .copyWith(color: ColorManager.black),
                      //     ),
                      //     DefaultTextField(
                      //         controller: cubit.bankNameController,
                      //         hintText: '',
                      //         validator: (value) {
                      //           return '';
                      //         },
                      //         keyboardType: TextInputType.text,
                      //         textInputAction: TextInputAction.next,
                      //         fillColor: ColorManager.gray),
                      //   ],
                      // ),
                      // SizedBox(height: mediaQuery.height * 0.03),
                      // /// account owner name
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     Text(
                      //       ' :اسم صاحب الحساب',
                      //       style: TextStyles.textStyle18Bold
                      //           .copyWith(color: ColorManager.black),
                      //     ),
                      //     DefaultTextField(
                      //         controller: cubit.accountOwnerNameController,
                      //         hintText: '',
                      //         validator: (value) {
                      //           return '';
                      //         },
                      //         keyboardType: TextInputType.text,
                      //         textInputAction: TextInputAction.next,
                      //         fillColor: ColorManager.gray),
                      //   ],
                      // ),
                      // SizedBox(height: mediaQuery.height * 0.03),
                      // /// iban number
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     Text(
                      //       ' :رقم الآيبان',
                      //       style: TextStyles.textStyle18Bold
                      //           .copyWith(color: ColorManager.black),
                      //     ),
                      //     DefaultTextField(
                      //         controller: cubit.ibanNumberController,
                      //         hintText: '',
                      //         validator: (value) {
                      //           return '';
                      //         },
                      //         keyboardType: TextInputType.number,
                      //         textInputAction: TextInputAction.done,
                      //         fillColor: ColorManager.gray),
                      //
                      //   ],
                      // ),
                      // SizedBox(height: mediaQuery.height * 0.26),
                      /// share and save
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// share button
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: mediaQuery.height * .055,
                              width: mediaQuery.width * .4,
                              decoration: BoxDecoration(
                                color:  ColorManager.primaryBlue,
                                borderRadius:
                                BorderRadius.circular(mediaQuery.height * 0.05),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'اضافة اخرى',
                                      style: TextStyles.textStyle18Bold.copyWith(
                                          color: ColorManager.white
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// save button
                          GestureDetector(
                            onTap: () {
                              if(cubit.giftValue == 0){
                                customToast(title: "من فضلك ادخل المبلغ", color: ColorManager.error);
                                return;
                              }else{
                                cubit.addOccasion();

                              }
                            },
                            child: Container(
                              height: mediaQuery.height * .055,
                              width: mediaQuery.width * .4,
                              decoration: BoxDecoration(
                                color: ColorManager.primaryBlue
                                ,
                                borderRadius:
                                BorderRadius.circular(mediaQuery.height * 0.05),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'حفظ',
                                      style: TextStyles.textStyle18Bold.copyWith(
                                          color:  ColorManager.white
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )

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
