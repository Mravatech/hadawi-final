import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/occasion_qr.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/loading_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../utiles/router/app_router.dart';

class OccasionSummary extends StatelessWidget {
  OccasionSummary({
    super.key,
  });

  final GlobalKey<FormState> discountCardKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionCubit, OccasionState>(
      listener: (context, state) {
        if (state is AddOccasionSuccessState) {
          context.read<OccasionCubit>().resetData();
          customPushNavigator(
              context,
              OccasionQr(
                occasionId: state.occasion.occasionId,
                occasionName: state.occasion.occasionName,
              ));
        } else if (state is AddOccasionErrorState) {
          // Show error message
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<OccasionCubit>();
        final mediaQuery = MediaQuery.sizeOf(context);
        return Scaffold(
          backgroundColor: ColorManager.white,
          appBar: AppBar(
              backgroundColor: ColorManager.gray,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back)),
              title: Text(
                AppLocalizations.of(context)!
                    .translate('occasionSummary')
                    .toString(),
                style: TextStyles.textStyle18Bold
                    .copyWith(color: ColorManager.black),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      context.replace(AppRouter.home);
                    },
                    child: Image(
                        image: AssetImage(AssetsManager.logoWithoutBackground)),
                  ),
                ),
              ]),
          body: ModalProgressHUD(
            inAsyncCall: state is AddOccasionLoadingState? true : false,
            progressIndicator: LoadingAnimationWidget(),
            child: SingleChildScrollView(
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.translate('occasionName').toString()} : ",
                          style: TextStyles.textStyle12Bold
                              .copyWith(color: ColorManager.black),
                        ),
                        Expanded(
                          child: Text(
                            cubit.occasionNameController.text,
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.primaryBlue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mediaQuery.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.translate('occasionType').toString()} : ",
                          style: TextStyles.textStyle12Bold
                              .copyWith(color: ColorManager.black),
                        ),
                        Expanded(
                          child: Text(
                            cubit.dropdownOccasionType,
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.primaryBlue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mediaQuery.height * 0.01),

                    /// person name if for other
                    Visibility(
                      visible: cubit.isForMe == false ? true : false,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('personName').toString()} : ",
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          Expanded(
                            child: Text(
                              cubit.nameController.text,
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.primaryBlue),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: cubit.isForMe == false ? true : false,
                        child: SizedBox(height: mediaQuery.height * 0.01)),

                    /// gift data
                    Visibility(
                      visible: cubit.isPresent == true ? true : false,
                      child: Column(
                        children: [
                          /// gift name
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.translate('giftName').toString()} : ",
                                style: TextStyles.textStyle12Bold
                                    .copyWith(color: ColorManager.black),
                              ),
                              Expanded(
                                child: Text(
                                  cubit.giftNameController.text,
                                  style: TextStyles.textStyle12Bold.copyWith(
                                      color: ColorManager.primaryBlue),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: mediaQuery.height * 0.01),

                          /// link
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.translate('link').toString()} : ",
                                style: TextStyles.textStyle12Bold
                                    .copyWith(color: ColorManager.black),
                              ),
                              Expanded(
                                child: Text(
                                  cubit.linkController.text,
                                  style: TextStyles.textStyle12Bold.copyWith(
                                      color: ColorManager.primaryBlue),
                                ),
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
                              cubit.image == null
                                  ? Container()
                                  : Container(
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
                      visible: cubit.isPresent == true ? true : false,
                      child: SizedBox(height: mediaQuery.height * 0.01),
                    ),

                    SizedBox(
                      height: SizeConfig.height * 0.01,
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
                          cubit.moneyAmountController.text.toString(),
                          style: TextStyles.textStyle12Bold
                              .copyWith(color: ColorManager.primaryBlue),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('rsa')
                              .toString(),
                          style: TextStyles.textStyle12Regular
                              .copyWith(color: ColorManager.primaryBlue),
                        )
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
                          cubit.giftWithPackage == true
                              ? AppLocalizations.of(context)!
                                  .translate('withPackaging')
                                  .toString()
                              : AppLocalizations.of(context)!
                                  .translate('withoutPackaging')
                                  .toString(),
                          style: TextStyles.textStyle12Bold
                              .copyWith(color: ColorManager.primaryBlue),
                        ),
                      ],
                    ),

                    SizedBox(height: mediaQuery.height * 0.01),

                    /// packaging price
                    Visibility(
                      visible: cubit.giftWithPackage == true ? true : false,
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
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .translate('rsa')
                                .toString(),
                            style: TextStyles.textStyle12Regular
                                .copyWith(color: ColorManager.primaryBlue),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: ColorManager.gray,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(SizeConfig.height * 0.01),
                              child: Image.network(
                                cubit.selectedPackageImage.toString(),
                                fit: BoxFit.fill,
                                height: mediaQuery.height * 0.05,
                                width: mediaQuery.height * 0.05,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: cubit.giftWithPackage == true ? true : false,
                        child: SizedBox(height: mediaQuery.height * 0.01)),

                    Visibility(
                      visible: cubit.isPresent == false &&
                              cubit.giftWithPackage == false
                          ? true
                          : false,
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

                    Visibility(
                        visible: cubit.isPresent == false &&
                                cubit.giftWithPackage == false
                            ? true
                            : false,
                        child: SizedBox(height: mediaQuery.height * 0.01)),

                    /// receiver city if is gift
                    Visibility(
                      visible: cubit.isPresent == true ||
                              (cubit.isPresent == false &&
                                  cubit.giftWithPackage == true)
                          ? true
                          : false,
                      child: Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('City').toString()} : ",
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          Text(
                            cubit.dropdownCity,
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.primaryBlue),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: cubit.isPresent == true ||
                                (cubit.isPresent == false &&
                                    cubit.giftWithPackage == true)
                            ? true
                            : false,
                        child: SizedBox(height: mediaQuery.height * 0.01)),

                    /// receiver the District if is gift
                    Visibility(
                      visible: cubit.isPresent == true ||
                              (cubit.isPresent == false &&
                                  cubit.giftWithPackage == true)
                          ? true
                          : false,
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
                    Visibility(
                        visible: cubit.isPresent == true ||
                                (cubit.isPresent == false &&
                                    cubit.giftWithPackage == true)
                            ? true
                            : false,
                        child: SizedBox(height: mediaQuery.height * 0.01)),

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
                    // Row(
                    //   children: [
                    //     Text(
                    //       "${AppLocalizations.of(context)!.translate('receivingTime').toString()} : ",
                    //       style: TextStyles.textStyle12Bold
                    //           .copyWith(color: ColorManager.black),
                    //     ),
                    //     Text(
                    //       cubit.moneyReceiveDateController.text,
                    //       style: TextStyles.textStyle12Bold
                    //           .copyWith(color: ColorManager.primaryBlue),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: mediaQuery.height * 0.01),
                    cubit.giftContainsNameValue == true
                        ? Text(
                            "${AppLocalizations.of(context)!.translate('containsNames').toString()} ",
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.primaryBlue),
                          )
                        : Text(
                            "${AppLocalizations.of(context)!.translate('noContainsNames').toString()} ",
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.primaryBlue),
                          ),
                    SizedBox(height: mediaQuery.height * 0.01),

                    /// message
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.translate('giftCard').toString()} : ",
                          style: TextStyles.textStyle12Bold
                              .copyWith(color: ColorManager.black),
                        ),
                        Expanded(
                          child: Text(
                            cubit.moneyGiftMessageController.text,
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.primaryBlue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mediaQuery.height * 0.01),

                    /// note if is gift
                    Visibility(
                      visible: cubit.isPresent == true ||
                              (cubit.isPresent == false &&
                                  cubit.giftWithPackage == true)
                          ? true
                          : false,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('note').toString()} : ",
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          Expanded(
                            child: Text(
                              cubit.giftDeliveryNoteController.text,
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.primaryBlue),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: mediaQuery.height * 0.01),

                    // Row(
                    //   children: [
                    //     Text(
                    //       "${AppLocalizations.of(context)!.translate('appCommission').toString()} : ",
                    //       style: TextStyles.textStyle12Bold
                    //           .copyWith(color: ColorManager.black),
                    //     ),
                    //     Text(
                    //       cubit.getAppCommission().toString(),
                    //       style: TextStyles.textStyle12Bold
                    //           .copyWith(color: ColorManager.primaryBlue),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Text(
                    //       AppLocalizations.of(context)!
                    //           .translate('rsa')
                    //           .toString(),
                    //       style: TextStyles.textStyle12Regular
                    //           .copyWith(color: ColorManager.primaryBlue),
                    //     )
                    //   ],
                    // ),
                    // SizedBox(height: mediaQuery.height * 0.01),

                    if(cubit.giftType != 'مبلغ مالي' && cubit.giftWithPackage != false)
                    Row(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.translate('deliveryPrice').toString()} : ",
                          style: TextStyles.textStyle12Bold
                              .copyWith(color: ColorManager.black),
                        ),
                        SizedBox(width: mediaQuery.height * 0.01,),
                        Expanded(
                          child: Text(
                            "${cubit.deliveryTax.toString()} ${AppLocalizations.of(context)!
                                .translate('rsa')} المطلوب مبلغ مالي بدون تغليف وسيتم التحويل البنكي",
                            style: TextStyles.textStyle12Regular
                                .copyWith(color: ColorManager.primaryBlue),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: mediaQuery.height * 0.01),

                    Visibility(
                      visible: cubit.showDiscountValue == true ? true : false,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.translate('discountAmount').toString()} : ",
                                style: TextStyles.textStyle12Bold
                                    .copyWith(color: ColorManager.black),
                              ),
                              Text(
                                cubit.discountValue.toString(),
                                style: TextStyles.textStyle12Bold
                                    .copyWith(color: ColorManager.primaryBlue),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .translate('rsa')
                                    .toString(),
                                style: TextStyles.textStyle12Regular
                                    .copyWith(color: ColorManager.primaryBlue),
                              ),
                            ],
                          ),
                          SizedBox(height: mediaQuery.height * 0.01),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.translate('totalAmount').toString()} : ",
                          style: TextStyles.textStyle12Bold
                              .copyWith(color: ColorManager.black),
                        ),
                        Text(
                          cubit.getTotalGiftPrice().toString(),
                          style: TextStyles.textStyle12Bold
                              .copyWith(color: ColorManager.primaryBlue),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('rsa')
                              .toString(),
                          style: TextStyles.textStyle12Regular
                              .copyWith(color: ColorManager.primaryBlue),
                        ),
                      ],
                    ),

                    Visibility(
                      visible: cubit.showDiscountField == true ? true : false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: mediaQuery.height * 0.01,
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.translate('addDiscountCardMessage').toString()} ",
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          SizedBox(height: mediaQuery.height * 0.01),
                          Form(
                            key: discountCardKey,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: DefaultTextField(
                                      controller: cubit.discountCodeController,
                                      hintText: AppLocalizations.of(context)!
                                          .translate('discountCardHint')
                                          .toString(),
                                      validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          return AppLocalizations.of(context)!
                                              .translate('validateDiscountCard')
                                              .toString();
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      fillColor: ColorManager.gray),
                                ),
                                SizedBox(
                                  width: SizeConfig.height * 0.01,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (discountCardKey.currentState!
                                        .validate()) {
                                      cubit.getDiscountCode();
                                    }
                                  },
                                  child: state
                                          is GetOccasionDiscountLoadingState
                                      ? LoadingAnimationWidget()
                                      : Container(
                                          height: mediaQuery.height * .055,
                                          width: mediaQuery.width * .2,
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
                                                    .translate('apply')
                                                    .toString(),
                                                style: TextStyles
                                                    .textStyle12Bold
                                                    .copyWith(
                                                        color:
                                                            ColorManager.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: mediaQuery.height * 0.05),

                    /// share and save
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        state is AddOccasionLoadingState
                            ? LoadingAnimationWidget()
                            : GestureDetector(
                                onTap: () async {
                                  context.read<OccasionCubit>().addOccasion();
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
                                            .translate('createOccasion')
                                            .toString(),
                                        style: TextStyles.textStyle12Bold
                                            .copyWith(
                                                color: ColorManager.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        GestureDetector(
                          onTap: () async {
                            cubit.switchDiscountField();
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
                                  cubit.showDiscountField
                                      ? AppLocalizations.of(context)!
                                          .translate('cancel')
                                          .toString()
                                      : AppLocalizations.of(context)!
                                          .translate('addDiscountCard')
                                          .toString(),
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
