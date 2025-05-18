import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/payment_screen.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/widgets/progress_indicator_widget.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/edit_occasion.dart';
import 'package:hadawi_app/generated/assets.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/loading_widget.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../occasions_list/presentation/controller/occasions_list_cubit.dart';

class OccasionDetails extends StatefulWidget {
  final String occasionId;
  final bool fromHome;

  const OccasionDetails({super.key, required this.occasionId, required this.fromHome});

  @override
  State<OccasionDetails> createState() => _OccasionDetailsState();
}

class _OccasionDetailsState extends State<OccasionDetails>{
  int _currentIndex = 0;
  final GlobalKey qrKey = GlobalKey();
  late Future<void> _initializationFuture;
  bool isLoading = false;



  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    isLoading = true;
    await UserDataFromStorage.getData();

    // Fetch occasion data
    await context.read<VisitorsCubit>().getOccasionData(occasionId: widget.occasionId);

    // Create dynamic link
    await context.read<OccasionCubit>().createDynamicLink(widget.occasionId);

    // Now it's safe to access occasionDetailsModel
    final cubit = context.read<VisitorsCubit>();
    final model = cubit.occasionDetailsModel;

    cubit.editOccasionNameController.text = model.type;
    cubit.editGiftNameController.text = model.giftName;
    cubit.editPersonNameController.text = model.personName;
    cubit.remainingBalanceController.text = model.moneyGiftAmount > model.giftPrice?
          "0.0": (model.giftPrice - model.moneyGiftAmount).toString();
  }



  @override
  void dispose() {
    final cubit = context.read<VisitorsCubit>();
    cubit.editOccasionNameController.dispose();
    cubit.editGiftNameController.dispose();
    cubit.editPersonNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initializationFuture = _initializeData();
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
      body: BlocConsumer<VisitorsCubit, VisitorsState>(
        listener: (context, state) {
          if (state is SendFollowRequestErrorState) {
            customToast(title: state.message, color: ColorManager.error);
          }
          if (state is EditOccasionSuccessState) {
            context.read<OccasionsListCubit>().getMyOccasionsList();
            Navigator.pop(context);
          }
        },
  builder: (context, state) {
      final cubit = context.read<VisitorsCubit>();
    return FutureBuilder<void>(
        future: _initializationFuture,
        builder: (context, snapshot) {
          if (state is GetOccasionDataLoadingState) {
            isLoading = true;
            return Center(child: LoadingAnimationWidget());
          }

          if (state is GetOccasionDataErrorState) {
            isLoading = false;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading data: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _initializationFuture = _initializeData();
                      });
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if(state is GetOccasionDataSuccessState){
            isLoading = true;
            final cubit = context.read<VisitorsCubit>();
            final model = cubit.occasionDetailsModel;

            cubit.editOccasionNameController.text = model.type;
            cubit.editGiftNameController.text = model.giftName;
            cubit.editPersonNameController.text = model.personName;
            cubit.remainingBalanceController.text = model.moneyGiftAmount > model.giftPrice?
            "0.0": (model.giftPrice - model.moneyGiftAmount).toString();
            isLoading = false;
          }

          return isLoading ? Center(child: LoadingAnimationWidget(),) : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CashHelper.languageKey == 'ar'
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  /// person name
                  Row(
                    children: [
                      CircleAvatar(
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: ColorManager.primaryBlue,
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
                      (UserDataFromStorage.userIsGuest == true) ||
                          (UserDataFromStorage.uIdFromStorage ==
                              cubit.occasionDetailsModel.personId)
                          ? Container()
                          : SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.3,
                        child: DefaultButton(
                          buttonText: AppLocalizations.of(context)!
                              .translate('follow')
                              .toString(),
                          onPressed: () {
                            context.read<VisitorsCubit>()
                                .sendFollowRequest(
                              userId: cubit.occasionDetailsModel.personId,
                              followerId: UserDataFromStorage.uIdFromStorage,
                              userName: cubit.occasionDetailsModel.personName,
                              image: cubit.occasionDetailsModel.giftImage.isNotEmpty ?
                              cubit.occasionDetailsModel.giftImage[0] ?? "" : "",
                            )
                                .then((value) {
                              customToast(
                                  title: 'تم الارسال',
                                  color: ColorManager.primaryBlue);
                            });
                          },
                          buttonColor: ColorManager.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  DefaultTextField(
                    controller: cubit.editPersonNameController,
                    hintText: '',
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
                    AppLocalizations.of(context)!
                        .translate('gift')
                        .toString(),
                    style: TextStyles.textStyle18Bold.copyWith(),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  DefaultTextField(
                    controller: cubit.editGiftNameController,
                    hintText: '',
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
                  _buildGiftImageSection(cubit),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),

                  /// gift link and progress indicator
                  Row(
                    children: [
                      Expanded(
                        child: ProgressIndicatorWidget(
                          value: (double.parse(cubit.occasionDetailsModel.moneyGiftAmount.toString()) /
                              double.parse(cubit.occasionDetailsModel.giftPrice.toString())),
                        ),
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
                    controller: cubit.remainingBalanceController,
                    hintText: '',
                    validator: (value) {
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorManager.gray,
                    enable: false,
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),

                  _buildQrCodeSection(cubit, state),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),

                  /// share and pay
                  _buildActionButtons(cubit, state),
                ],
              ),
            ),
          );
        },
      );
  },
),
    );
  }

  Widget _buildGiftImageSection(VisitorsCubit cubit) {
    // Skip if it's a money gift with no images
    if (cubit.occasionDetailsModel.giftImage.isEmpty &&
        cubit.occasionDetailsModel.giftType == 'مبلغ مالى') {
      return SizedBox();
    }

    return Container(
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
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              padEnds: false,
              viewportFraction: .99,
              height: MediaQuery.sizeOf(context).height * 0.378,
              aspectRatio: 16 / 6,
              enlargeCenterPage: true,
              enlargeFactor: 0.1,
              enableInfiniteScroll: false,
              initialPage: 0,
              pageSnapping: false,
              autoPlay: false,
              disableCenter: true,
              onPageChanged: (index, _) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: [
              ...cubit.occasionDetailsModel.giftImage.map((item) => Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: CachedNetworkImage(
                  imageUrl: item,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) {
                    return cubit.occasionDetailsModel.giftImage.isEmpty &&
                        cubit.occasionDetailsModel.giftType == 'مبلغ مالي'
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
              ))
            ],
          ),
          Positioned(
            bottom: 23,
            left: 0,
            right: 0,
            child: DotsIndicator(
              dotsCount: cubit.occasionDetailsModel.giftImage.isEmpty ? 1 : cubit.occasionDetailsModel.giftImage.length,
              position: _currentIndex.toDouble(),
              decorator: DotsDecorator(
                spacing: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                color: Colors.white,
                size: Size(8, 8),
                activeSize: Size(24, 6),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                activeColor: ColorManager.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodeSection(VisitorsCubit cubit, VisitorsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RepaintBoundary(
          key: qrKey,
          child: QrImageView(
            data: context.read<OccasionCubit>().occasionLink,
            version: QrVersions.auto,
            size: SizeConfig.height * 0.25,
            backgroundColor: Colors.white,
            embeddedImage: AssetImage(AssetsManager.logoWithoutBackground),
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size(100, 100),
            ),
          ),
        ),
        state is CreateOccasionLinkLoadingState
            ? LoadingAnimationWidget()
            : GestureDetector(
          onTap: () async {
            context.read<OccasionCubit>().captureAndShareQr(
                qrKey: qrKey,
                occasionName: cubit.occasionDetailsModel.type,
                personName: UserDataFromStorage.userNameFromStorage);
          },
          child: Container(
            height: MediaQuery.sizeOf(context).height * .055,
            width: MediaQuery.sizeOf(context).width * .3,
            decoration: BoxDecoration(
              color: ColorManager.primaryBlue,
              borderRadius: BorderRadius.circular(
                  MediaQuery.sizeOf(context).height * 0.05),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('shareQr')
                      .toString(),
                  style: TextStyles.textStyle12Bold
                      .copyWith(color: ColorManager.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(VisitorsCubit cubit, VisitorsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /// share button
        GestureDetector(
          onTap: () async {
            String link = await cubit.createDynamicLink(widget.occasionId);
            Share.share(
                'قام صديقك ${cubit.occasionDetailsModel.personName} بدعوتك للمشاركة في مناسبة له ${cubit.occasionDetailsModel.type} للمساهمة بالدفع اضغط على الرابط ادناه لرؤية تفاصيل عن الهدية: $link');
          },
          child: state is CreateOccasionLinkLoadingState
              ? LoadingAnimationWidget()
              : Container(
            height: MediaQuery.sizeOf(context).height * .055,
            width: MediaQuery.sizeOf(context).width * .25,
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
        SizedBox(width: MediaQuery.sizeOf(context).width * .02),

        /// pay button
        GestureDetector(
          onTap: () {
            if (double.parse(cubit.remainingBalanceController.text) > 0 || cubit.occasionDetailsModel.giftPrice > cubit.occasionDetailsModel.moneyGiftAmount) {
              customPushNavigator(
                  context,
                  PaymentScreen(
                    occasionEntity: cubit.occasionDetailsModel,
                  ));
            } else {
              customToast(
                  title: AppLocalizations.of(context)!
                      .translate('paymentComplete')
                      .toString(),
                  color: ColorManager.warning);
            }
          },
          child: Container(
            height: MediaQuery.sizeOf(context).height * .055,
            width: MediaQuery.sizeOf(context).width * .25,
            decoration: BoxDecoration(
              color: double.parse(cubit.remainingBalanceController.text) > 0 || cubit.occasionDetailsModel.giftPrice > cubit.occasionDetailsModel.moneyGiftAmount
                  ? ColorManager.primaryBlue
                  : ColorManager.gray,
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
        SizedBox(width: MediaQuery.sizeOf(context).width * .02),

        /// edit button
        if (UserDataFromStorage.uIdFromStorage == cubit.occasionDetailsModel.personId)
          state is EditOccasionLoadingState
              ? LoadingAnimationWidget()
              : GestureDetector(
            onTap: () {
              customPushNavigator(
                context,
                EditOccasion(
                  occasionModel: cubit.occasionDetailsModel,
                  fromHome: widget.fromHome,
                ),
              );
            },
            child: Container(
              height: MediaQuery.sizeOf(context).height * .055,
              width: MediaQuery.sizeOf(context).width * .25,
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
                          .translate('edit')
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
    );
  }
}