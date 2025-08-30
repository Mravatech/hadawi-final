import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/payment_screen.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/widgets/progress_indicator_widget.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/visitors_screen.dart';
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

class _OccasionDetailsState extends State<OccasionDetails> {
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
    if (mounted) {
      setState(() => isLoading = true);
    }
    try {
      await UserDataFromStorage.getData();
      await context.read<VisitorsCubit>().getOccasionData(occasionId: widget.occasionId);
      await context.read<OccasionCubit>().createDynamicLink(widget.occasionId);

      final cubit = context.read<VisitorsCubit>();
      final model = cubit.occasionDetailsModel;
      cubit.editOccasionNameController.text = model.type;
      cubit.editGiftNameController.text = model.giftName;
      cubit.editPersonNameController.text = model.personName;
      cubit.remainingBalanceController.text = model.moneyGiftAmount > model.giftPrice
          ? "0.0"
          : (model.giftPrice - model.moneyGiftAmount).toString();
    } catch (e) {
      debugPrint('Error initializing data: $e');
      if (mounted) {
        customToast(
          title: AppLocalizations.of(context)!.translate('error').toString(),
          color: ColorManager.error
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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
    return Scaffold(
      backgroundColor: Color(0xFFF8F7FB), // Light purple background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: !kIsWeb
            ? IconButton(
                icon: Icon(
                  CashHelper.languageKey == 'ar' ? Icons.arrow_forward : Icons.arrow_back,
                  color: ColorManager.black,
                ),
                onPressed: () {
                  widget.fromHome
                      ? (UserDataFromStorage.userIsGuest
                          ? customPushAndRemoveUntil(context, VisitorsScreen())
                          : customPushAndRemoveUntil(context, HomeLayout()))
                      : Navigator.pop(context);
                },
              )
            : SizedBox(),
        title: Text(
          AppLocalizations.of(context)!.translate('occasionDetails').toString(),
          style: TextStyles.textStyle18Bold.copyWith(
            color: ColorManager.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              Assets.imagesLogoWithoutBackground,
              height: 32,
            ),
          )
        ],
      ),
      body: BlocConsumer<VisitorsCubit, VisitorsState>(
        listener: (context, state) {
          if(state is SendFollowRequestSuccessState){
            customToast(title: AppLocalizations.of(context)!.translate('followRequestSentSuccessfully').toString(), color: ColorManager.success);
          }
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

          debugPrint("uer id ${UserDataFromStorage.uIdFromStorage}");
          debugPrint("person id ${cubit.occasionDetailsModel.occasionId}");

          if (state is GetOccasionDataLoadingState || isLoading) {
            return Center(child: LoadingAnimationWidget());
          }

          if (state is GetOccasionDataErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate('error').toString(),
                    style: TextStyles.textStyle18Bold,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _initializationFuture = _initializeData()),
                    icon: Icon(Icons.refresh),
                    label: Text(AppLocalizations.of(context)!.translate('retry').toString()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8B7BA8),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          if (cubit.occasionDetailsModel == null) {
            return Center(child: LoadingAnimationWidget());
          }

          final model = cubit.occasionDetailsModel;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  // Person Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFFF0EEF5),
                          child: Icon(Icons.person, color: Color(0xFF8B7BA8), size: 28),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.personName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                model.type,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if ((UserDataFromStorage.userIsGuest == false) &&
                      (UserDataFromStorage.uIdFromStorage !=
                          cubit.occasionDetailsModel.personId))
                          ElevatedButton(
                            onPressed: () => cubit.sendFollowRequest(
                              userId: model.personId,
                              followerId: UserDataFromStorage.uIdFromStorage,
                              userName: model.personName,
                              image: "",
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8B7BA8),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.person_add, size: 18, color: Colors.white),
                                SizedBox(width: 4),
                                Text(AppLocalizations.of(context)!.translate('follow').toString()),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Progress Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate('goal').toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  '${model.giftPrice.toStringAsFixed(0)} ${AppLocalizations.of(context)!.translate('rsa').toString()}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate('collected').toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  '${model.moneyGiftAmount.toStringAsFixed(0)} ${AppLocalizations.of(context)!.translate('rsa').toString()}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              Container(
                                height: 12,
                                color: Color(0xFFF0EEF5),
                              ),
                              FractionallySizedBox(
                                widthFactor: (model.moneyGiftAmount / model.giftPrice).clamp(0.0, 1.0),
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF8B7BA8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${((model.moneyGiftAmount / model.giftPrice) * 100).toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8B7BA8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (model.giftPrice > model.moneyGiftAmount)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${AppLocalizations.of(context)!.translate('remainingBalance').toString()}: ${(model.giftPrice - model.moneyGiftAmount).toStringAsFixed(0)} ${AppLocalizations.of(context)!.translate('rsa').toString()}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // QR Code Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        RepaintBoundary(
                          key: qrKey,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: QrImageView(
                              data: context.read<OccasionCubit>().occasionLink,
                              version: QrVersions.auto,
                              size: 200,
                              embeddedImage: AssetImage(AssetsManager.logoWithoutBackground),
                              embeddedImageStyle: QrEmbeddedImageStyle(size: Size(40, 40)),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        if (state is! CreateOccasionLinkLoadingState)
                          ElevatedButton.icon(
                            onPressed: () => context.read<OccasionCubit>().captureAndShareQr(
                              qrKey: qrKey,
                              occasionName: model.type,
                              personName: UserDataFromStorage.userNameFromStorage,
                            ),
                            icon: Icon(Icons.share, color: Colors.white),
                            label: Text(AppLocalizations.of(context)!.translate('shareQr').toString()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8B7BA8),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              minimumSize: Size(200, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              cubit.occasionDetailsModel.isActive==true ? () async {
                            String link = await cubit.createDynamicLink(widget.occasionId);
                            Share.share(
                                CashHelper.getData(key: CashHelper.languageKey).toString()=="en"?'Your friend invited you to join the occasion of ${cubit.occasionDetailsModel.personName} (${cubit.occasionDetailsModel.type}). To contribute, click the link below to view the gift details: $link'
                                    :'قام صديقك بدعوتك للمشاركة في مناسبة ${cubit.occasionDetailsModel.personName} ${cubit.occasionDetailsModel.type} للمساهمة بالدفع اضغط على الرابط ادناه لرؤية تفاصيل عن الهدية: $link'
                            );
                          }:null,
                          icon: Icon(Icons.share, color: cubit.occasionDetailsModel.isActive==true ? Colors.white:Colors.grey),
                          label: Text(AppLocalizations.of(context)!.translate('share').toString()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cubit.occasionDetailsModel.isActive==true ?  Color(0xFF8B7BA8):Colors.grey,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: cubit.occasionDetailsModel.isActive==true ? () {
                            customPushNavigator(
                              context,
                              PaymentScreen(occasionEntity: model),
                            );
                          }:null,
                          icon: Icon(Icons.payment, color: cubit.occasionDetailsModel.isActive==true ? Colors.white:Colors.grey),
                          label: Text(AppLocalizations.of(context)!.translate('payNow').toString()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:cubit.occasionDetailsModel.isActive==true ?  Color(0xFF8B7BA8):Colors.grey,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      if (UserDataFromStorage.uIdFromStorage == cubit.occasionDetailsModel.personId)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: cubit.occasionDetailsModel.isActive==true ? () {
                              customPushNavigator(
                                context,
                                EditOccasion(
                                  occasionModel: cubit.occasionDetailsModel,
                                  fromHome: widget.fromHome,
                                ),
                              );
                            }:null,
                            icon: Icon(Icons.edit,color:  cubit.occasionDetailsModel.isActive==true ?  Colors.white:Colors.grey),
                            label: Text(AppLocalizations.of(context)!.translate('edit').toString()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cubit.occasionDetailsModel.isActive==true ? Color(0xFF8B7BA8):Colors.grey,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // ElevatedButton.icon(
                  //   onPressed: () async {
                  //     String link = "https://hadawi-payment.web.app/occasion-details/${widget.occasionId}";
                  //     Share.share(
                  //         CashHelper.getData(key: CashHelper.languageKey).toString()=="en"?'Your friend invited you to join the occasion of ${cubit.occasionDetailsModel.personName} (${cubit.occasionDetailsModel.type}). To contribute, click the link below to view the gift details: $link'
                  //             :'قام صديقك بدعوتك للمشاركة في مناسبة ${cubit.occasionDetailsModel.personName} ${cubit.occasionDetailsModel.type} للمساهمة بالدفع اضغط على الرابط ادناه لرؤية تفاصيل عن الهدية: $link'
                  //     );
                  //   },
                  //   icon: Icon(Icons.link, color: Colors.white),
                  //   label: Text(AppLocalizations.of(context)!.translate('createPaymentLink').toString()),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Color(0xFF8B7BA8),
                  //     foregroundColor: Colors.white,
                  //     elevation: 0,
                  //     padding: EdgeInsets.symmetric(vertical: 16),
                  //     minimumSize: Size(double.infinity, 48),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(24),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGiftImageSection(VisitorsCubit cubit) {
    if (cubit.occasionDetailsModel.giftImage.isEmpty &&
        cubit.occasionDetailsModel.giftType == 'مبلغ مالى') {
      return SizedBox();
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.35,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              onPageChanged: (index, _) => setState(() => _currentIndex = index),
            ),
            items: cubit.occasionDetailsModel.giftImage.map((item) => Container(
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: item,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            )).toList(),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: DotsIndicator(
              dotsCount: cubit.occasionDetailsModel.giftImage.length,
              position: _currentIndex.toDouble(),
              decorator: DotsDecorator(
                activeColor: ColorManager.primaryBlue,
                color: Colors.white.withOpacity(0.5),
                activeSize: Size(24, 8),
                size: Size(8, 8),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodeSection(VisitorsCubit cubit, VisitorsState state) {
    return Column(
      children: [
        RepaintBoundary(
          key: qrKey,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data: context.read<OccasionCubit>().occasionLink,
              version: QrVersions.auto,
              size: 200,
              embeddedImage: AssetImage(AssetsManager.logoWithoutBackground),
              embeddedImageStyle: QrEmbeddedImageStyle(size: Size(40, 40)),
            ),
          ),
        ),
        SizedBox(height: 16),
        if (state is! CreateOccasionLinkLoadingState)
          ElevatedButton.icon(
            onPressed: () => context.read<OccasionCubit>().captureAndShareQr(
              qrKey: qrKey,
              occasionName: cubit.occasionDetailsModel.type,
              personName: UserDataFromStorage.userNameFromStorage,
            ),
            icon: Icon(Icons.share, color: Colors.white),
            label: Text(AppLocalizations.of(context)!.translate('shareQr').toString()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8B7BA8),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(VisitorsCubit cubit, VisitorsState state, bool isActiveOccasion) {
    if (!isActiveOccasion) return SizedBox();

    final bool canInteract = cubit.occasionDetailsModel.giftPrice > cubit.occasionDetailsModel.moneyGiftAmount;
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: canInteract ? ColorManager.primaryBlue : Colors.grey,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: canInteract ? () async {
                  String link = await cubit.createDynamicLink(widget.occasionId);
                  Share.share(
                      CashHelper.getData(key: CashHelper.languageKey).toString()=="en"?'Your friend ${cubit.occasionDetailsModel.personName} has invited you to their ${cubit.occasionDetailsModel.type}. To contribute, click the link below to view the gift details: $link'
                          :'قام صديقك ${cubit.occasionDetailsModel.personName} بدعوتك للمشاركة في مناسبة له ${cubit.occasionDetailsModel.type} للمساهمة بالدفع اضغط على الرابط ادناه لرؤية تفاصيل عن الهدية: $link'
                  );
                } : null,
                icon: Icon(Icons.share, color: Colors.white),
                label: Text(AppLocalizations.of(context)!.translate('share').toString()),
                style: buttonStyle,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: canInteract ? () {
                  customPushNavigator(
                    context,
                    PaymentScreen(occasionEntity: cubit.occasionDetailsModel),
                  );
                } : null,
                icon: Icon(Icons.payment, color: Colors.white),
                label: Text(AppLocalizations.of(context)!.translate('payNow').toString()),
                style: buttonStyle,
              ),
            ),
          ],
        ),
        if (UserDataFromStorage.uIdFromStorage == cubit.occasionDetailsModel.personId && canInteract)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                customPushNavigator(
                  context,
                  EditOccasion(
                    occasionModel: cubit.occasionDetailsModel,
                    fromHome: widget.fromHome,
                  ),
                );
              },
              icon: Icon(Icons.edit, color: Colors.white),
              label: Text(AppLocalizations.of(context)!.translate('edit').toString()),
              style: buttonStyle,
            ),
          ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: canInteract ? () async {
            String link = "https://hadawi-payment.web.app/occasion-details/${widget.occasionId}";
            Share.share(
                CashHelper.getData(key: CashHelper.languageKey).toString()=="en"?'Your friend invited you to join the occasion of ${cubit.occasionDetailsModel.personName} (${cubit.occasionDetailsModel.type}). To contribute, click the link below to view the gift details: $link'
                    :'قام صديقك بدعوتك للمشاركة في مناسبة ${cubit.occasionDetailsModel.personName} ${cubit.occasionDetailsModel.type} للمساهمة بالدفع اضغط على الرابط ادناه لرؤية تفاصيل عن الهدية: $link'
            );
          } : null,
          icon: Icon(Icons.link, color: Colors.white),
          label: Text(AppLocalizations.of(context)!.translate('createPaymentLink').toString()),
          style: buttonStyle,
        ),
      ],
    );
  }
}
