import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/active_occasion_card.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_card.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_details.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/search_bar_widget.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/search_result_container.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/tutorial_coach_widget.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/visitors_home_shimmer.dart';
import 'package:hadawi_app/generated/assets.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/localiztion/localization_cubit.dart';
import 'package:hadawi_app/utiles/localiztion/localization_states.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/utiles/services/notification_service.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/toastification_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toastification/toastification.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
                                context.read<VisitorsCubit>().lanuchToUrl(banner.url);
                              },
                              child: CachedNetworkImage(
                                imageUrl: banner.image,
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
                    height: mediaQuery.height * 0.2,
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
                              height: SizeConfig.height * 0.045,
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
                            SizedBox(
                              height: SizeConfig.height * 0.02,
                            ),
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
                              padding: const EdgeInsets.all(10.0),
                              child: SearchBarWidget(
                                onChanged: (value) async {
                                  print('search value $value');
                                  cubit.search(value);
                                },
                                searchController: cubit.searchController,
                              ),
                            ),

                            state is GetOccasionsStillLoadingState ||
                                    cubit.activeOccasions.isEmpty &&
                                    cubit.doneOccasions.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Center(child: CircularProgressIndicator()),
                                    ],
                                  )
                                : cubit.isActiveOrders
                                    ? cubit.activeOccasions.isNotEmpty
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
                                          )
                                    : cubit.doneOccasions.isNotEmpty
                                        ? Column(
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                              ),
                                              child: Text('اضغط على الصورة لتكبيرها، واسحب لليمين او اليسار لمشاهدة الصور الأخرى',
                                                textAlign: TextAlign.center,
                                                style: TextStyles.textStyle18Medium.copyWith(color: ColorManager.primaryBlue,fontWeight: FontWeight.bold,fontSize: 12),),
                                            ),
                                            GridView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                padding: const EdgeInsets.all(15),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        mainAxisSpacing: 15,
                                                        crossAxisSpacing: 15,
                                                        crossAxisCount: 2,
                                                        childAspectRatio: 1 / 1.1),
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                      onTap: () {},
                                                      child: OccasionCard(
                                                        occasionEntity: cubit
                                                            .doneOccasions[index],
                                                      ));
                                                },
                                                itemCount:
                                                    cubit.doneOccasions.length,
                                              ),
                                          ],
                                        )
                                        : SizedBox(
                                            height: SizeConfig.height * 0.25,
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .translate(
                                                        "occasionsListEmpty")
                                                    .toString(),
                                                style: TextStyles
                                                    .textStyle18Medium
                                                    .copyWith(
                                                        color: ColorManager
                                                            .primaryBlue),
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
