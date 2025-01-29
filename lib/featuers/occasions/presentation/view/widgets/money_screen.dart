import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/present_amount_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
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
            body: Padding(
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
                      mainAxisAlignment: CashHelper.languageKey == 'ar'
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.translate('share').toString()} ",
                          style: TextStyles.textStyle12Bold
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

                    /// amount
                    Row(
                      mainAxisAlignment: CashHelper.languageKey == 'ar'
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.translate('moneyAmount').toString()} ",
                          style: TextStyles.textStyle12Bold
                              .copyWith(color: ColorManager.black),
                        ),
                        PresentAmountWidget(),

                      ],
                    ),
                   Spacer(),

                    /// share and save
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// save button
                        GestureDetector(
                          onTap: () {
                            if (cubit.giftPrice == 0) {
                              customToast(
                                  title: AppLocalizations.of(context)!
                                      .translate('validateMoneyAmount')
                                      .toString(),
                                  color: ColorManager.error);
                            } else {
                              cubit.addOccasion();
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
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('save')
                                      .toString(),
                                  style: TextStyles.textStyle18Bold
                                      .copyWith(color: ColorManager.white),
                                ),
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
        );
      },
    );
  }
}
