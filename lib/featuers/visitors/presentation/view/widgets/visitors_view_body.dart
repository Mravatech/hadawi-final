import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/active_occasion_card.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_details.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/search_bar_widget.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/search_result_container.dart';
import 'package:hadawi_app/generated/assets.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:hadawi_app/widgets/toastification_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toastification/toastification.dart';

import '../../../../../styles/colors/color_manager.dart';
import '../../../../../utiles/shared_preferences/shared_preference.dart';

class VisitorsViewBody extends StatefulWidget {
  const VisitorsViewBody({super.key});

  @override
  State<VisitorsViewBody> createState() => _VisitorsViewBodyState();
}

class _VisitorsViewBodyState extends State<VisitorsViewBody>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _loadBannerData();
  }

  void _loadBannerData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('Starting banner data load');
      context.read<VisitorsCubit>().getBannerData().then((_) {
        debugPrint('Banner data load completed');
        // Add a small delay to ensure the state is updated
        Future.delayed(Duration(milliseconds: 100), () {
          _showBannerPopupIfNeeded();
        });
      });
    });
  }

  void _showBannerPopupIfNeeded() async {
    final hasShownBannerValue = await CashHelper.getData(key: 'has_shown_banner');
    final lastBannerIds = await CashHelper.getData(key: 'last_banner_ids') ?? '';
    final banners = context.read<VisitorsCubit>().banners;
    
    // Create a string of current banner IDs
    final currentBannerIds = banners.map((b) => b.id).join(',');
    
    debugPrint('hasShownBannerValue: $hasShownBannerValue');
    debugPrint('lastBannerIds: $lastBannerIds');
    debugPrint('currentBannerIds: $currentBannerIds');
    debugPrint('mounted: $mounted');
    
    // Show if never shown before OR if banner IDs have changed
    if ((hasShownBannerValue == null || lastBannerIds != currentBannerIds) && mounted && banners.isNotEmpty) {
      debugPrint('Showing banner popup');
      
      int currentPage = 0;
      
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PageView.builder(
                          itemCount: banners.length,
                          onPageChanged: (index) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final banner = banners[index];
                            return GestureDetector(
                              onTap: () {
                                if (banner.actionUrl != null) {
                                  context.read<VisitorsCubit>().lanuchToUrl(banner.actionUrl!);
                                }
                              },
                              child: CachedNetworkImage(
                                imageUrl: banner.imageUrl ?? '',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                        ),
                        // Page indicator
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              banners.length,
                              (index) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                width: currentPage == index ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: currentPage == index 
                                    ? ColorManager.primaryBlue
                                    : Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  top: -10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(Icons.close, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      // Save both the shown state and the current banner IDs
      await CashHelper.saveData(key: 'has_shown_banner', value: true);
      await CashHelper.saveData(key: 'last_banner_ids', value: currentBannerIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("user===> ${UserDataFromStorage.uIdFromStorage}");
    return BlocBuilder<VisitorsCubit, VisitorsState>(
      builder: (context, state) {
        final mediaQuery = MediaQuery.sizeOf(context);
        final cubit = context.read<VisitorsCubit>();
        return ModalProgressHUD(
          inAsyncCall: state is GetOccasionsLoadingState,
          progressIndicator: CupertinoActivityIndicator(),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: mediaQuery.height * 0.15,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        height: mediaQuery.height * 0.2,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: SizeConfig.height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: mediaQuery.width * 0.05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          Assets.imagesLogoWithoutBackground,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.05,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CashHelper.languageKey == 'ar'
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${AppLocalizations.of(context)!.translate('welcome').toString()},",
                                            style: TextStyles.textStyle18Bold
                                                .copyWith(
                                                    color: ColorManager.black),
                                          ),
                                          Visibility(
                                            visible: UserDataFromStorage
                                                        .userIsGuest ==
                                                    false
                                                ? true
                                                : false,
                                            child: Text(
                                              UserDataFromStorage
                                                  .userNameFromStorage,
                                              style: TextStyles
                                                  .textStyle18Medium
                                                  .copyWith(
                                                      color:
                                                          ColorManager.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  // BlocBuilder<LocalizationCubit,
                                  //     LocalizationStates>(
                                  //   builder: (context, state) {
                                  //     return GestureDetector(
                                  //       onTap: () {
                                  //         CashHelper.getData(
                                  //                         key: CashHelper
                                  //                             .languageKey)
                                  //                     .toString() ==
                                  //                 'en'
                                  //             ? context
                                  //                 .read<LocalizationCubit>()
                                  //                 .changeLanguage(code: 'ar')
                                  //             : context
                                  //                 .read<LocalizationCubit>()
                                  //                 .changeLanguage(code: 'en');
                                  //       },
                                  //       child: Container(
                                  //           padding: EdgeInsets.symmetric(
                                  //             horizontal:
                                  //                 MediaQuery.sizeOf(context)
                                  //                         .width *
                                  //                     0.04,
                                  //             vertical:
                                  //                 MediaQuery.sizeOf(context)
                                  //                         .width *
                                  //                     0.01,
                                  //           ),
                                  //           decoration: BoxDecoration(
                                  //             color: Colors.transparent,
                                  //             borderRadius:
                                  //                 BorderRadius.circular(10),
                                  //           ),
                                  //           child: CashHelper.getData(
                                  //                           key: CashHelper
                                  //                               .languageKey)
                                  //                       .toString() ==
                                  //                   'en'
                                  //               ? Text(
                                  //                   'English',
                                  //                   style: TextStyles
                                  //                       .textStyle18Bold
                                  //                       .copyWith(
                                  //                           color: ColorManager
                                  //                               .black,
                                  //                           fontSize: MediaQuery
                                  //                                       .sizeOf(
                                  //                                           context)
                                  //                                   .height *
                                  //                               0.018),
                                  //                 )
                                  //               : Text('عربي',
                                  //                   style: TextStyles
                                  //                       .textStyle18Bold
                                  //                       .copyWith(
                                  //                           color: ColorManager
                                  //                               .black,
                                  //                           fontSize: MediaQuery
                                  //                                       .sizeOf(
                                  //                                           context)
                                  //                                   .height *
                                  //                               0.018))),
                                  //     );
                                  //   },
                                  // ),
                                  Visibility(
                                    visible:
                                        UserDataFromStorage.userIsGuest == true
                                            ? true
                                            : false,
                                    child: IconButton(
                                      onPressed: () {
                                        customPushReplacement(
                                            context, LoginScreen());
                                      },
                                      icon: const Icon(Icons.login_outlined),
                                      color: ColorManager.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                     
                            // Active Orders and Completed Orders tabs commented out
                            // Container(
                            //   height: SizeConfig.height * 0.06,
                            //   width: SizeConfig.width,
                            //   decoration: BoxDecoration(
                            //     color: ColorManager.gray,
                            //     borderRadius: BorderRadius.only(
                            //         topLeft: Radius.circular(20),
                            //         topRight: Radius.circular(20)),
                            //   ),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //       InkWell(
                            //         onTap: () async {
                            //           if (UserDataFromStorage.userIsGuest ==
                            //               false) {
                            //             await AuthCubit.get(context)
                            //                 .getUserInfo(
                            //                     uId: UserDataFromStorage
                            //                         .uIdFromStorage,
                            //                     context: context);
                            //             if (UserDataFromStorage
                            //                     .uIdFromStorage ==
                            //                 '') {
                            //               toastificationWidget(
                            //                   context: context,
                            //                   title: AppLocalizations.of(
                            //                           context)!
                            //                       .translate('errorOccurred')
                            //                       .toString(),
                            //                   body: AppLocalizations.of(
                            //                           context)!
                            //                       .translate('deleteMessage')
                            //                       .toString(),
                            //                   type: ToastificationType.error);
                            //               customPushReplacement(
                            //                   context, LoginScreen());
                            //             } else {
                            //               if (UserDataFromStorage
                            //                       .isUserBlocked ==
                            //                   true) {
                            //                 AuthCubit.get(context).logout();
                            //                 customPushReplacement(
                            //                     context, LoginScreen());
                            //                 toastificationWidget(
                            //                     context: context,
                            //                     title: AppLocalizations.of(
                            //                             context)!
                            //                         .translate('blockOccurred')
                            //                         .toString(),
                            //                     body: AppLocalizations.of(
                            //                             context)!
                            //                         .translate('blockMessage')
                            //                         .toString(),
                            //                     type: ToastificationType.error);
                            //               } else {
                            //                 cubit.changeActiveOrders(true);
                            //               }
                            //             }
                            //           } else {
                            //             cubit.changeActiveOrders(true);
                            //           }
                            //         },
                            //         child: Container(
                            //           height: SizeConfig.height * 0.06,
                            //           width: SizeConfig.width * 0.5,
                            //           decoration: BoxDecoration(
                            //             color: cubit.isActiveOrders
                            //                 ? ColorManager.primaryBlue
                            //                 : ColorManager.gray,
                            //             borderRadius: CashHelper.getData(
                            //                             key: CashHelper
                            //                                 .languageKey)
                            //                         .toString() ==
                            //                     'en'
                            //                 ? BorderRadius.only(
                            //                     topLeft: Radius.circular(20),
                            //                   )
                            //                 : BorderRadius.only(
                            //                     topRight: Radius.circular(20)),
                            //           ),
                            //           child: Center(
                            //             child: Text(
                            //               AppLocalizations.of(context)!
                            //                   .translate('activeOrders')
                            //                   .toString(),
                            //               style: TextStyles.textStyle18Medium
                            //                   .copyWith(
                            //                       color: ColorManager.black),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       InkWell(
                            //         onTap: () async {
                            //           if (UserDataFromStorage.userIsGuest ==
                            //               false) {
                            //             await AuthCubit.get(context)
                            //                 .getUserInfo(
                            //                     uId: UserDataFromStorage
                            //                         .uIdFromStorage,
                            //                     context: context);
                            //             if (UserDataFromStorage
                            //                     .uIdFromStorage ==
                            //                 '') {
                            //               toastificationWidget(
                            //                   context: context,
                            //                   title: AppLocalizations.of(
                            //                           context)!
                            //                       .translate('errorOccurred')
                            //                       .toString(),
                            //                   body: AppLocalizations.of(
                            //                           context)!
                            //                       .translate('deleteMessage')
                            //                       .toString(),
                            //                   type: ToastificationType.error);
                            //               customPushReplacement(
                            //                   context, LoginScreen());
                            //             } else {
                            //               if (UserDataFromStorage
                            //                       .isUserBlocked ==
                            //                   true) {
                            //                 AuthCubit.get(context).logout();
                            //                 customPushReplacement(
                            //                     context, LoginScreen());
                            //                 toastificationWidget(
                            //                     context: context,
                            //                     title: AppLocalizations.of(
                            //                             context)!
                            //                         .translate('blockOccurred')
                            //                         .toString(),
                            //                     body: AppLocalizations.of(
                            //                             context)!
                            //                         .translate('blockMessage')
                            //                         .toString(),
                            //                     type: ToastificationType.error);
                            //               } else {
                            //                 cubit.changeActiveOrders(false);
                            //               }
                            //             }
                            //           } else {
                            //             cubit.changeActiveOrders(false);
                            //           }
                            //         },
                            //         child: Container(
                            //           height: SizeConfig.height * 0.06,
                            //           width: SizeConfig.width * 0.5,
                            //           decoration: BoxDecoration(
                            //             color: cubit.isActiveOrders
                            //                 ? ColorManager.gray
                            //                 : ColorManager.primaryBlue,
                            //             borderRadius: CashHelper.getData(
                            //                             key: CashHelper
                            //                                 .languageKey)
                            //                         .toString() ==
                            //                     'en'
                            //                 ? BorderRadius.only(
                            //                     topRight: Radius.circular(20))
                            //                 : BorderRadius.only(
                            //                     topLeft: Radius.circular(20)),
                            //           ),
                            //           child: Center(
                            //             child: Text(
                            //               AppLocalizations.of(context)!
                            //                   .translate('completedOrders')
                            //                   .toString(),
                            //               style: TextStyles.textStyle18Medium
                            //                   .copyWith(
                            //                       color: ColorManager.black),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        )),
                  ),

                  /// body
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        cubit.getOccasions();
                      },
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            /// search bar
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SearchBarWidget(
                                onChanged: (value) async {
                                  print('search value $value');
                                  cubit.search(value);
                                },
                                searchController: cubit.searchController,
                              ),
                            ),

                            /// Banner Carousel
                            BlocBuilder<VisitorsCubit, VisitorsState>(
                              builder: (context, state) {
                                debugPrint('Banner count: ${cubit.banners.length}');
                                debugPrint('Banner: ${cubit.banners}');
                                debugPrint('Banner state: $state');
                                
                                if (cubit.banners.isEmpty) {
                                  debugPrint('Banners list is empty, showing default banner');
                                  // Show default banner if no banners are loaded
                                  return Container(
                                    height: 120,
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Color(0xFF1a1a1a), Color(0xFF2d2d2d), Color(0xFF1a1a1a)],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [Color(0xFF1a1a1a), Color(0xFF2d2d2d), Color(0xFF1a1a1a)],
                                              ),
                                            ),
                                            child: CustomPaint(
                                              painter: StripesPainter(),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF00FF88),
                                                  borderRadius: BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFF00FF88).withOpacity(0.5),
                                                      blurRadius: 20,
                                                      spreadRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '%',
                                                    style: TextStyle(
                                                      fontSize: 36,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      shadows: [
                                                        Shadow(
                                                          color: Colors.black.withOpacity(0.3),
                                                          offset: Offset(2, 2),
                                                          blurRadius: 4,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'عروض تحلي الاحتفال',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: Color(0xFFFF6B35),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: Text(
                                                        'اطلب الآن',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                
                                return Column(
                                  children: [
                                    Container(
                                      height: 120,
                                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: PageView.builder(
                                        controller: cubit.bannerController,
                                        itemCount: cubit.banners.length,
                                        onPageChanged: (index) {
                                          cubit.updateBannerIndex(index);
                                        },
                                        itemBuilder: (context, index) {
                                          // Debug banner data
                                          debugPrint('Banner $index - Image URL: ${cubit.banners[index].imageUrl}');
                                          debugPrint('Banner $index - Title: ${cubit.banners[index].title}');
                                          debugPrint('Banner $index - Icon: ${cubit.banners[index].icon}');
                                          debugPrint('Banner $index - Action URL: ${cubit.banners[index].actionUrl}');
                                          
                                          // Ensure we have at least 2 colors for the gradient
                                          List<Color> bannerColors = cubit.banners[index].colors;
                                          if (bannerColors.length < 2) {
                                            bannerColors = [bannerColors.isNotEmpty ? bannerColors[0] : Colors.grey, Colors.grey[300]!];
                                          }
                                          
                                          return GestureDetector(
                                            onTap: () {
                                              debugPrint('Banner tapped: ${cubit.banners[index].id}');
                                              debugPrint('Banner action URL: ${cubit.banners[index].actionUrl}');
                                              if (cubit.banners[index].actionUrl != null) {
                                                cubit.lanuchToUrl(cubit.banners[index].actionUrl!);
                                              }
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(16),
                                                child: Stack(
                                                  children: [
                                                    // Background image or gradient
                                                    Positioned.fill(
                                                      child: cubit.banners[index].imageUrl != null && cubit.banners[index].imageUrl!.isNotEmpty
                                                          ? CachedNetworkImage(
                                                              imageUrl: cubit.banners[index].imageUrl!,
                                                              fit: BoxFit.cover,
                                                              placeholder: (context, url) {
                                                                debugPrint('Loading banner image: ${cubit.banners[index].imageUrl}');
                                                                return Container(
                                                                  decoration: BoxDecoration(
                                                                    gradient: LinearGradient(
                                                                      begin: Alignment.topLeft,
                                                                      end: Alignment.bottomRight,
                                                                      colors: bannerColors,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: CircularProgressIndicator(
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              errorWidget: (context, url, error) {
                                                                debugPrint('Error loading banner image: $error');
                                                                debugPrint('Failed URL: $url');
                                                                return Container(
                                                                  decoration: BoxDecoration(
                                                                    gradient: LinearGradient(
                                                                      begin: Alignment.topLeft,
                                                                      end: Alignment.bottomRight,
                                                                      colors: bannerColors,
                                                                    ),
                                                                  ),
                                                                  child: CustomPaint(
                                                                    painter: StripesPainter(),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          : Container(
                                                              decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                  begin: Alignment.topLeft,
                                                                  end: Alignment.bottomRight,
                                                                  colors: bannerColors,
                                                                ),
                                                              ),
                                                              child: CustomPaint(
                                                                painter: StripesPainter(),
                                                              ),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(
                                        cubit.banners.length,
                                        (index) => Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 4),
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: cubit.currentBannerIndex == index
                                                ? ColorManager.primaryBlue
                                                : Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            state is GetOccasionsLoadingState || state is GetOccasionsStillLoadingState
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Center(child: CircularProgressIndicator()),
                                    ],
                                  )
                                : cubit.activeOccasions.isEmpty && cubit.doneOccasions.isEmpty
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 100),
                                          Text(
                                            AppLocalizations.of(context)!.translate('noOccasionsFound') ?? 'No occasions found',
                                            style: TextStyles.textStyle16Regular,
                                          ),
                                        ],
                                      )
                                : cubit.activeOccasions.isNotEmpty
                                    ? ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(16),
                                        itemCount: cubit.activeOccasions.length,
                                        separatorBuilder: (context, index) => SizedBox(height: 16),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () async {
                                              if (UserDataFromStorage.userIsGuest == false) {
                                                await AuthCubit.get(context).getUserInfo(
                                                  uId: UserDataFromStorage.uIdFromStorage,
                                                  context: context
                                                );
                                                if (UserDataFromStorage.uIdFromStorage == '') {
                                                  toastificationWidget(
                                                    context: context,
                                                    title: AppLocalizations.of(context)!.translate('errorOccurred').toString(),
                                                    body: AppLocalizations.of(context)!.translate('deleteMessage').toString(),
                                                    type: ToastificationType.error
                                                  );
                                                  customPushReplacement(context, LoginScreen());
                                                } else {
                                                  if (UserDataFromStorage.isUserBlocked == true) {
                                                    customPushReplacement(context, LoginScreen());
                                                    toastificationWidget(
                                                      context: context,
                                                      title: AppLocalizations.of(context)!.translate('blockOccurred').toString(),
                                                      body: AppLocalizations.of(context)!.translate('blockMessage').toString(),
                                                      type: ToastificationType.error
                                                    );
                                                  } else {
                                                    customPushNavigator(
                                                      context,
                                                      BlocProvider(
                                                        create: (context) => VisitorsCubit(getIt(), getIt(), getIt()),
                                                        child: OccasionDetails(
                                                          occasionId: cubit.activeOccasions[index].occasionId,
                                                          fromHome: true,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              } else {
                                                customPushNavigator(
                                                  context,
                                                  BlocProvider.value(
                                                    value: cubit,
                                                    child: OccasionDetails(
                                                      occasionId: cubit.activeOccasions[index].occasionId,
                                                      fromHome: true,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: ActiveOccasionCard(
                                              occasionEntity: cubit.activeOccasions[index],
                                            ),
                                          );
                                        },
                                      )
                                    : SizedBox(
                                        height: SizeConfig.height * 0.25,
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate("occasionsListEmpty")
                                                .toString(),
                                            style: TextStyles.textStyle18Medium
                                                .copyWith(color: ColorManager.primaryBlue),
                                          ),
                                        ),
                                      ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              cubit.searchOccasionsList.isEmpty ||
                      cubit.searchController.text.trim().isEmpty
                  ? SizedBox()
                  : Positioned(
                      top: mediaQuery.height * 0.55,
                      left: mediaQuery.width * 0.05,
                      right: mediaQuery.width * 0.05,
                      child: SearchResultContainer(),
                    )
            ],
          ),
        );
      },
    );
  }
}

// Custom painter for the banner background stripes
class StripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw vertical stripes
    for (double i = 0; i < size.width; i += 8) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
