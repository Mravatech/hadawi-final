import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/data/models/occasion_model.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/payment_screen.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/loading_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class OccasionQr extends StatefulWidget {
  final OccasionEntity occasionModel;

  const OccasionQr({
    super.key,
    required this.occasionModel
  });

  @override
  State<OccasionQr> createState() => _OccasionQrState();
}

class _OccasionQrState extends State<OccasionQr> with WidgetsBindingObserver{
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<OccasionCubit>().createDynamicLink(widget.occasionModel.occasionId);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Cache the image provider to prevent multiple loads
  final ImageProvider _logoProvider = AssetImage(AssetsManager.logoWithoutBackground);
  final GlobalKey qrKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache the image to prevent repeated loading
    precacheImage(_logoProvider, context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionCubit, OccasionState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<OccasionCubit>();
        final mediaQuery = MediaQuery.sizeOf(context);
        return Scaffold(
          backgroundColor: ColorManager.white,
          appBar: AppBar(
              backgroundColor: ColorManager.gray,
              leading: IconButton(
                  onPressed: () {
                    customPushNavigator(context, HomeLayout());
                  },
                  icon: Icon(Icons.arrow_back)),
              title: Text(
                AppLocalizations.of(context)!
                    .translate('occasionQr')
                    .toString(),
                style: TextStyles.textStyle18Bold
                    .copyWith(color: ColorManager.black),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    context.replace(AppRouter.home);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(image: _logoProvider),
                  ),
                ),
              ]),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: mediaQuery.height * 0.02,
                  ),
                  Text(
                    widget.occasionModel.occasionType.toString(),
                    style: TextStyles.textStyle12Bold
                        .copyWith(color: ColorManager.black),
                  ),

                  SizedBox(
                    height: mediaQuery.height * 0.02,
                  ),
                  state is CreateOccasionLinkLoadingState
                      ? LoadingAnimationWidget()
                      : cubit.occasionLink.isNotEmpty
                      ? RepaintBoundary(
                    key: qrKey,
                    child: QrImageView(
                      data: cubit.occasionLink,
                      version: QrVersions.auto,
                      size: SizeConfig.height * 0.3,
                      backgroundColor: Colors.white,
                      embeddedImage: _logoProvider,
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(100, 100),
                      ),
                    ),
                  )
                      : SizedBox(
                    height: SizeConfig.height * 0.3,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.primaryBlue,
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.height * 0.05),

                  /// share and save
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// share
                      GestureDetector(
                        onTap: () async {
                          String link = await cubit
                              .createDynamicLink(widget.occasionModel.occasionId);
                          Share.share(
                              'قام صديقك ${widget.occasionModel.personName??""} بدعوتك للمشاركة في مناسبة ${widget.occasionModel.occasionType} للمساهمة بالدفع اضغط ع الرابط ادناه لرؤية تفاصيل عن الهدية: $link');
                        },
                        child: state is CreateOccasionLinkLoadingState
                            ? LoadingAnimationWidget()
                            : Container(
                          height:
                          MediaQuery.sizeOf(context).height *
                              .055,
                          width: MediaQuery.sizeOf(context).width *
                              .25,
                          decoration: BoxDecoration(
                            color: ColorManager.primaryBlue,
                            borderRadius: BorderRadius.circular(
                                MediaQuery.sizeOf(context).height *
                                    0.05),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('share')
                                      .toString(),
                                  style: TextStyles.textStyle18Bold
                                      .copyWith(
                                      color:
                                      ColorManager.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      /// pay
                      GestureDetector(
                        onTap: () => customPushNavigator(
                            context,
                            PaymentScreen(
                              occasionEntity: widget.occasionModel,
                            )),
                        child: Container(
                          height:
                          MediaQuery.sizeOf(context).height * .055,
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
                                      .translate('payNow')
                                      .toString(),
                                  style: TextStyles.textStyle18Bold
                                      .copyWith(
                                      color: ColorManager.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      /// share qr
                      GestureDetector(
                        onTap: () async {
                          if (cubit.occasionLink.isNotEmpty) {
                            await cubit.captureAndShareQr(
                              qrKey: qrKey,
                                occasionName: widget.occasionModel.occasionType.toString(),
                                personName: UserDataFromStorage.userNameFromStorage);
                          }
                        },
                        child: Container(
                          height: mediaQuery.height * .055,
                          width: mediaQuery.width * .4,
                          decoration: BoxDecoration(
                            color: ColorManager.primaryBlue,
                            borderRadius:
                            BorderRadius.circular(mediaQuery.height * 0.05),
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
                  ),
                  SizedBox(height: mediaQuery.height * 0.05),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}