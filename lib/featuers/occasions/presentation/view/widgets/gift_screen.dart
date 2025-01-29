import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/present_amount_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../utiles/localiztion/app_localization.dart';

class GiftScreen extends StatelessWidget {
  const GiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionCubit, OccasionState>(
      listener: (BuildContext context, state) {
        if (state is AddOccasionSuccessState) {
          customToast(
              title: AppLocalizations.of(context)!
                  .translate('occasionAddedSuccessfully')
                  .toString(),
              color: ColorManager.success);
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
          UserDataFromStorage.setIsForMe(true);
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
                     .translate('gift')
                     .toString(),
                 style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
               ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                        image: AssetImage(AssetsManager.logoWithoutBackground)),
                  ),

                ]),
            body: Padding(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.giftFormKey,
                  child: Column(
                    crossAxisAlignment: CashHelper.languageKey == 'ar'
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      /// by sharing switch
                      Row(
                        mainAxisAlignment: CashHelper.languageKey == 'ar'
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .translate('share')
                                .toString(),
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          Switch(
                              value: cubit.bySharingValue,
                              onChanged: (value) {
                                cubit.switchBySharing();
                              }),
                        ],
                      ),
                      SizedBox(height: mediaQuery.height * 0.03),

                      /// gift name
                      Text(
                        AppLocalizations.of(context)!
                            .translate('giftName')
                            .toString(),
                        style: TextStyles.textStyle18Bold
                            .copyWith(color: ColorManager.black),
                      ),
                      SizedBox(height: mediaQuery.height * 0.01),
                      DefaultTextField(
                          controller: cubit.giftNameController,
                          hintText: AppLocalizations.of(context)!
                              .translate('giftNameHint')
                              .toString(),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AppLocalizations.of(context)!
                                  .translate('validateGiftName')
                                  .toString();
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          fillColor: ColorManager.gray),
                      SizedBox(height: mediaQuery.height * 0.04),

                      /// link
                      Text(
                        AppLocalizations.of(context)!
                            .translate('link')
                            .toString(),
                        style: TextStyles.textStyle18Bold
                            .copyWith(color: ColorManager.black),
                      ),
                      SizedBox(height: mediaQuery.height * 0.01),
                      DefaultTextField(
                          controller: cubit.linkController,
                          hintText: AppLocalizations.of(context)!
                              .translate('linkHint')
                              .toString(),
                          validator: (value) {
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          fillColor: ColorManager.gray),

                      SizedBox(height: mediaQuery.height * 0.04),

                      /// picture
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('gifPicture').toString()} ",
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          Container(
                            height: mediaQuery.height * 0.2,
                            width: mediaQuery.width * 0.5,
                            decoration: BoxDecoration(
                                color: ColorManager.gray,
                                borderRadius: BorderRadius.circular(10)),
                            child: cubit.image == null
                                ? Center(
                                    child: Container(),
                                  )
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
                          ),
                          IconButton(
                              onPressed: () {
                                cubit.pickGiftImage();
                              },
                              icon: Icon(
                                Icons.file_upload_outlined,
                                size: mediaQuery.height * 0.04,
                                color: ColorManager.primaryBlue,
                              )),
                        ],
                      ),
                      SizedBox(height: mediaQuery.height * 0.04),

                      /// amount
                      Row(
                        mainAxisAlignment: CashHelper.languageKey == 'ar'
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('giftAmount').toString()} ",
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          PresentAmountWidget(),
                        ],
                      ),
                      SizedBox(height: mediaQuery.height * 0.12),

                      /// add another and save
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// save button
                          GestureDetector(
                            onTap: () {
                              if (cubit.giftFormKey.currentState!.validate() &&
                                  cubit.image != null &&
                                  cubit.giftPrice != 0) {
                                cubit.addOccasion();
                              } else {
                                customToast(
                                    title: AppLocalizations.of(context)!
                                        .translate('validateGiftScreen')
                                        .toString(),
                                    color: ColorManager.error);
                              }
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('save')
                                          .toString(),
                                      style: TextStyles.textStyle18Bold
                                          .copyWith(color: ColorManager.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// share button
                          GestureDetector(
                            onTap: () {},
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('addAnother')
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
