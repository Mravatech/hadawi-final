import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class OccasionSummary extends StatelessWidget {
  const OccasionSummary({super.key,});

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
                        .translate('occasionSummary')
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
                  child: Column(
                    crossAxisAlignment: CashHelper.languageKey == 'ar'
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      /// occasion name
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('occasionName').toString()} : ",
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          Text(
                            cubit.occasionNameController.text,
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.primaryBlue),
                          ),
                        ],
                      ),
                      SizedBox(height: mediaQuery.height * 0.01),
                      /// person name if for other
                      Visibility(
                        visible: cubit.isForMe == false ? true : false,
                        child: Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.translate('personName').toString()} : ",
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.black),
                            ),
                            Text(
                              cubit.nameController.text,
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.primaryBlue),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                          visible: cubit.isForMe == false ? true : false,
                          child: SizedBox(height: mediaQuery.height * 0.01)),

                      /// gift data
                      Visibility(
                        visible: cubit.isPresent == true? true : false,
                        child: Column(
                          children: [
                            /// gift name
                            Row(
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.translate('giftName').toString()} : ",
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.black),
                                ),
                                Text(
                                  cubit.giftNameController.text,
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.primaryBlue),
                                ),
                              ],
                            ),
                            SizedBox(height: mediaQuery.height * 0.01),
                            /// link
                            Row(
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.translate('link').toString()} : ",
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.black),
                                ),
                                Text(
                                  cubit.linkController.text,
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.primaryBlue),
                                ),
                              ],
                            ),
                            SizedBox(height: mediaQuery.height * 0.01),
                            /// picture
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.translate('gifPicture').toString()} ",
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.black),
                                ),
                                cubit.image == null? Container(): Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.file(
                                    cubit.image!,
                                    fit: BoxFit.fill,
                                    height: mediaQuery.height * 0.2,
                                    width: mediaQuery.width * 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: cubit.isPresent == true? true : false,
                          child: SizedBox(height: mediaQuery.height * 0.01),
                      ),

                      /// gift amount
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('giftAmount').toString()} : ",
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          Text(
                            cubit.giftPrice.toString(),
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.primaryBlue),
                          ),
                        ],
                      ),
                      SizedBox(height: mediaQuery.height * 0.01),
                      /// packaging
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('packaging').toString()}: ",
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          Text(
                            cubit.giftWithPackage == true? AppLocalizations.of(context)!.translate('withPackaging').toString(): AppLocalizations.of(context)!.translate('withoutPackaging').toString(),
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.primaryBlue),
                          ),
                        ],
                      ),

                      SizedBox(height: mediaQuery.height * 0.01),
                      /// packaging price
                      Visibility(
                        visible: cubit.giftWithPackage == true? true : false,
                        child: Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.translate('packagingPrice').toString()}: ",
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.black),
                            ),
                            Text(
                              cubit.giftWithPackageType.toString(),
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.primaryBlue),
                            ),
                          ],
                        ),
                      ),
                      Visibility( visible: cubit.giftWithPackage == true? true : false, child: SizedBox(height: mediaQuery.height * 0.01)),


                      Visibility(
                        visible: cubit.isPresent == false? true : false,
                        child: Column(
                          children: [
                            /// receiver name if is money
                            Row(
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.translate('moneyReceiverName').toString()} : ",
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.black),
                                ),
                                Text(
                                  cubit.giftReceiverNameController.text,
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.primaryBlue),
                                ),
                              ],
                            ),
                            SizedBox(height: mediaQuery.height * 0.01),
                            /// bank name if is money
                            Row(
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.translate('bankName').toString()} : ",
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.black),
                                ),
                                Text(
                                  cubit.bankNameController.text,
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.primaryBlue),
                                ),
                              ],
                            ),
                            SizedBox(height: mediaQuery.height * 0.01),
                            /// account iban number
                            Row(
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.translate('ibanNumber').toString()} : ",
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.black),
                                ),
                                Text(
                                  cubit.ibanNumberController.text,
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.primaryBlue),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: mediaQuery.height * 0.01),

                      /// receiver city if is gift
                      Visibility(
                        visible: cubit.isPresent == true? true : false,
                        child: Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.translate('City').toString()} : ",
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.black),
                            ),
                            Text(
                              cubit.giftDeliveryCityController.text,
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.primaryBlue),
                            ),
                          ],
                        ),
                      ),
                      Visibility( visible: cubit.isPresent == true? true : false, child: SizedBox(height: mediaQuery.height * 0.01)),
                      /// receiver the District if is gift
                      Visibility(
                        visible: cubit.isPresent == true? true : false,
                        child: Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.translate('theDistrict').toString()} : ",
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.black),
                            ),
                            Text(
                              cubit.giftDeliveryStreetController.text,
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.primaryBlue),
                            ),
                          ],
                        ),
                      ),
                      Visibility( visible: cubit.isPresent == true? true : false, child: SizedBox(height: mediaQuery.height * 0.01)),
                      /// receiver number
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('moneyReceiverPhone').toString()} : ",
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          Text(
                            cubit.giftReceiverNumberController.text,
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.primaryBlue),
                          ),
                        ],
                      ),
                      SizedBox(height: mediaQuery.height * 0.01),
                      /// date of receive
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('receivingTime').toString()} : ",
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          Text(
                            cubit.occasionDateController.text,
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.primaryBlue),
                          ),
                        ],
                      ),
                      SizedBox(height: mediaQuery.height * 0.01),
                      cubit.giftContainsNameValue == true? Text(
                        "${AppLocalizations.of(context)!.translate('containsNames').toString()} ",
                        style: TextStyles.textStyle12Bold
                            .copyWith(color: ColorManager.primaryBlue),
                      ):Text(
                        "${AppLocalizations.of(context)!.translate('noContainsNames').toString()} ",
                        style: TextStyles.textStyle12Bold
                            .copyWith(color: ColorManager.primaryBlue),
                      ),
                      SizedBox(height: mediaQuery.height * 0.01),


                      /// message
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('giftCard').toString()} : ",
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          Text(
                            cubit.moneyGiftMessageController.text,
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.primaryBlue),
                          ),
                        ],
                      ),
                      SizedBox(height: mediaQuery.height * 0.01),

                      /// note if is gift
                      Visibility(
                        visible: cubit.isPresent,
                        child: Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.translate('note').toString()} : ",
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.black),
                            ),
                            Text(
                              cubit.giftDeliveryNoteController.text,
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.primaryBlue),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: mediaQuery.height * 0.01),


                      SizedBox(height: mediaQuery.height * 0.05),
                      /// share and save
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            cubit.resetData();
                            customPushAndRemoveUntil(context, const HomeLayout());
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
                                      .translate('payAndShare')
                                      .toString(),
                                  style: TextStyles.textStyle12Bold
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
          );
        },
      );
  }
}
