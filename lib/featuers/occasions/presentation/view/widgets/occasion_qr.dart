import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _OccasionQrState extends State<OccasionQr> with WidgetsBindingObserver {
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final ImageProvider _logoProvider = AssetImage(AssetsManager.logoWithoutBackground);
  final GlobalKey qrKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => customPushNavigator(context, HomeLayout()),
              icon: Icon(Icons.arrow_back, color: ColorManager.black),
            ),
            title: Text(
              AppLocalizations.of(context)!.translate('occasionQr').toString(),
              style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: 'logo',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => customPushReplacement(context, HomeLayout()),
                      child: Image(image: _logoProvider),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: mediaQuery.height - kToolbarHeight - MediaQuery.of(context).padding.top - 50,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(mediaQuery.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                  // Occasion Type with animation
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: 1.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ColorManager.primaryBlue.withOpacity(0.1), ColorManager.primaryBlue.withOpacity(0.3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        widget.occasionModel.occasionType.toString(),
                        style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.height * 0.04),

                  // QR Code Container
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: state is CreateOccasionLinkLoadingState
                        ? LoadingAnimationWidget()
                        : cubit.occasionLink.isNotEmpty
                            ? RepaintBoundary(
                                key: qrKey,
                                child: QrImageView(
                                  data: cubit.occasionLink,
                                  version: QrVersions.auto,
                                  size: mediaQuery.width * 0.7,
                                  backgroundColor: Colors.white,
                                  embeddedImage: _logoProvider,
                                  embeddedImageStyle: QrEmbeddedImageStyle(
                                    size: Size(mediaQuery.width * 0.15, mediaQuery.width * 0.15),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: mediaQuery.width * 0.7,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: ColorManager.primaryBlue,
                                  ),
                                ),
                              ),
                  ),

                  SizedBox(height: mediaQuery.height * 0.06),

                  // Action Buttons
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildActionButton(
                        context: context,
                        icon: Icons.share,
                        label: AppLocalizations.of(context)!.translate('share').toString(),
                        onTap: () async {
                          String link = await cubit.createDynamicLink(widget.occasionModel.occasionId);
                          Share.share(
                            'قام صديقك ${widget.occasionModel.personName??""} بدعوتك للمشاركة في مناسبة له ${widget.occasionModel.type} للمساهمة بالدفع اضغط ع الرابط ادناه لرؤية تفاصيل عن الهدية: $link'
                          );
                        },
                        isLoading: state is CreateOccasionLinkLoadingState,
                      ),

                      _buildActionButton(
                        context: context,
                        icon: Icons.payment,
                        label: AppLocalizations.of(context)!.translate('payNow').toString(),
                        onTap: () => customPushNavigator(
                          context,
                          PaymentScreen(occasionEntity: widget.occasionModel),
                        ),
                      ),

                      _buildActionButton(
                        context: context,
                        icon: Icons.qr_code,
                        label: AppLocalizations.of(context)!.translate('shareQr').toString(),
                        onTap: () async {
                          if (cubit.occasionLink.isNotEmpty) {
                            await cubit.captureAndShareQr(
                              qrKey: qrKey,
                              occasionName: widget.occasionModel.occasionType.toString(),
                              personName: UserDataFromStorage.userNameFromStorage,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorManager.primaryBlue, ColorManager.primaryBlue.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.primaryBlue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyles.textStyle16Bold.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}