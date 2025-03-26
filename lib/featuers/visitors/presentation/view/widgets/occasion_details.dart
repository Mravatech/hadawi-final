import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/friends/presentation/controller/friends_cubit.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/payment_screen.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/widgets/progress_indicator_widget.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/progress_indecator.dart';
import 'package:hadawi_app/generated/assets.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/loading_widget.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OccasionDetails extends StatefulWidget {
  final String occasionId;

  const OccasionDetails({super.key, required this.occasionId});

  @override
  State<OccasionDetails> createState() => _OccasionDetailsState();
}

class _OccasionDetailsState extends State<OccasionDetails> {
  
  @override
  void initState() {
    // TODO: implement initState
    SharedPreferences.getInstance();
    UserDataFromStorage.getData();
    context.read<VisitorsCubit>().getOccasionData(occasionId: widget.occasionId);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.gray,
        surfaceTintColor: ColorManager.gray,
        title: Text(
          AppLocalizations.of(context)!.translate('occasionDetails').toString(),
          style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              Assets.imagesLogoWithoutBackground,
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<VisitorsCubit, VisitorsState>(
          listener: (context, state) {
            if(state is SendFollowRequestErrorState){
              customToast(title: state.message, color: ColorManager.error);
            }
          },
          builder: (context, state) {
            final cubit = context.read<VisitorsCubit>();
            return cubit.occasionModel !=null && state is! GetOccasionDataLoadingState? Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CashHelper.languageKey == 'ar'
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  /// occasion name
                  Text(
                    AppLocalizations.of(context)!
                        .translate('occasionName')
                        .toString(),
                    style: TextStyles.textStyle18Bold.copyWith(),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  DefaultTextField(
                    controller: TextEditingController(),
                    hintText: cubit.occasionModel!.occasionName,
                    validator: (value) {
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorManager.gray,
                    enable: false,
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),

                  /// person name
                  Row(
                    children: [
                      CircleAvatar(
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: cubit.occasionModel!.giftImage,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              color: ColorManager.primaryBlue,
                            ),
                            height: MediaQuery.sizeOf(context).height * 0.1,
                            width: MediaQuery.sizeOf(context).height * 0.1,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.02,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .translate('personName')
                            .toString(),
                        style: TextStyles.textStyle18Bold.copyWith(),
                      ),
                      Spacer(),
                      UserDataFromStorage.userIsGuest==false? SizedBox(
                        width:  MediaQuery.sizeOf(context).width * 0.3,
                        child: DefaultButton(
                            buttonText: AppLocalizations.of(context)!.translate('follow').toString(),
                            onPressed: () {
                               context.read<VisitorsCubit>().sendFollowRequest(
                                   userId: cubit.occasionModel!.personId,
                                   followerId: UserDataFromStorage.uIdFromStorage,
                                   userName: cubit.occasionModel!.personName,
                                   image: cubit.occasionModel!.giftImage,
                               ).then((value) {
                                 customToast(title: 'تم الارسال', color: ColorManager.primaryBlue);
                               });
                            },
                            buttonColor: ColorManager.primaryBlue,
                        ),
                      ):Container(),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  DefaultTextField(
                    controller: TextEditingController(),
                    hintText: cubit.occasionModel!.personName,
                    validator: (value) {
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorManager.gray,
                    enable: false,
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),

                  /// gift
                  Text(
                    AppLocalizations.of(context)!.translate('gift').toString(),
                    style: TextStyles.textStyle18Bold.copyWith(),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  DefaultTextField(
                    controller: TextEditingController(),
                    hintText: cubit.occasionModel!.giftName.isEmpty
                        ? '${cubit.occasionModel!.giftPrice} ريال'
                        : cubit.occasionModel!.giftName,
                    validator: (value) {
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorManager.gray,
                    enable: false,
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),

                  /// gift image
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.gray.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: cubit.occasionModel!.giftImage.isEmpty &&
                            cubit.occasionModel!.giftType == 'مبلغ مالي'
                        ? SizedBox()
                        : CachedNetworkImage(
                            imageUrl: cubit.occasionModel!.giftImage,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) {
                              return cubit.occasionModel!.giftImage.isEmpty &&
                                      cubit.occasionModel!.giftType == 'مبلغ مالي'
                                  ? Image.asset(
                                      'assets/images/money_bag.png',
                                      fit: BoxFit.contain,
                                    )
                                  : const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    );
                            },
                            height: MediaQuery.sizeOf(context).height * 0.3,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),

                  /// gift link and progress indicator
                  Row(
                    children: [
                      Expanded(
                        child: ProgressIndicatorWidget(
                            value: (double.parse(cubit.occasionModel!.moneyGiftAmount.toString()) /
                                double.parse(cubit.occasionModel!.giftPrice.toString()))
                        ) ,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),

                  /// remaining balance
                  Text(
                    AppLocalizations.of(context)!
                        .translate('remainingBalance')
                        .toString(),
                    style: TextStyles.textStyle18Bold.copyWith(),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  DefaultTextField(
                    controller: TextEditingController(),
                    hintText: (cubit.occasionModel!.giftPrice - cubit.occasionModel!.moneyGiftAmount).toString(),
                    validator: (value) {
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorManager.gray,
                    enable: false,
                  ),
                  SizedBox(
                    height:MediaQuery.sizeOf(context).height * 0.1
                  ),

                  /// share and pay
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          /// share
                          GestureDetector(
                            onTap: ()  async {
                              String link = await cubit.createDynamicLink(widget.occasionId);
                              Share.share('Check out this occasion: $link');
                            },
                            child: state is CreateOccasionLinkLoadingState? LoadingAnimationWidget() :Container(
                              height: MediaQuery.sizeOf(context).height * .055,
                              width: MediaQuery.sizeOf(context).width * .4,
                              decoration: BoxDecoration(
                                color: ColorManager.primaryBlue,
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.sizeOf(context).height * 0.05),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('share')
                                          .toString(),
                                      style: TextStyles.textStyle18Bold
                                          .copyWith(color: ColorManager.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width * .05),

                          /// pay
                          GestureDetector(
                            onTap: () => customPushNavigator(
                                context,
                                PaymentScreen(
                                  occasionEntity: cubit.occasionModel!,
                                )),
                            child: Container(
                              height: MediaQuery.sizeOf(context).height * .055,
                              width: MediaQuery.sizeOf(context).width * .4,
                              decoration: BoxDecoration(
                                color: ColorManager.primaryBlue,
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.sizeOf(context).height * 0.05),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('payNow')
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
                ],
              ),
            ) : const LoadingAnimationWidget();
          },
        ),
      ),
    );
  }
}
