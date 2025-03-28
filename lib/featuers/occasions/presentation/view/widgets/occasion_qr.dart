import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/widgets/loading_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OccasionQr extends StatefulWidget {
  final String occasionId;
  final String occasionName;

  const OccasionQr({
    super.key,
    required this.occasionId,
    required this.occasionName,
  });

  @override
  State<OccasionQr> createState() => _OccasionQrState();
}

class _OccasionQrState extends State<OccasionQr> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<OccasionCubit>().createDynamicLink(widget.occasionId);
    super.initState();
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
                    child: Image(
                        image: AssetImage(AssetsManager.logoWithoutBackground)),
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
                    widget.occasionName.toString(),
                    style: TextStyles.textStyle12Bold
                        .copyWith(color: ColorManager.black),
                  ),

                  SizedBox(
                    height: mediaQuery.height * 0.02,
                  ),
                  state is CreateOccasionLinkLoadingState
                      ? LoadingAnimationWidget()
                      : RepaintBoundary(
                          key: cubit.qrKey,
                          child: QrImageView(
                            data: cubit.occasionLink,
                            version: QrVersions.auto,
                            size: SizeConfig.height * 0.3,
                            backgroundColor: Colors.white,
                            embeddedImage:
                                AssetImage(AssetsManager.logoWithoutBackground),
                            // Your logo
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: Size(100, 100), // Adjust size as needed
                            ),
                          ),
                        ),

                  SizedBox(height: mediaQuery.height * 0.05),

                  /// share and save
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () async {
                        await cubit.captureAndShareQr(
                            occasionName: widget.occasionName);
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
                                  .translate('share')
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
        );
      },
    );
  }
}
