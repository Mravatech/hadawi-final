import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

class _VisitorsViewBodyState extends State<VisitorsViewBody> with WidgetsBindingObserver{


  @override
  void initState() {
    super.initState();
    context.read<VisitorsCubit>().getBannerData();
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
                          color: Colors.grey[300],
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
                              padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.05),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          Assets.imagesLogoWithoutBackground,
                                          height: MediaQuery.sizeOf(context).height * 0.05,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CashHelper.languageKey == 'ar'
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${AppLocalizations.of(context)!.translate('welcome').toString()},",
                                            style: TextStyles.textStyle18Bold
                                                .copyWith(color: ColorManager.black),
                                          ),
                                          Visibility(
                                            visible: UserDataFromStorage.userIsGuest == false? true:false,
                                            child: Text(
                                              UserDataFromStorage.userNameFromStorage,
                                              style: TextStyles.textStyle18Medium
                                                  .copyWith(color: ColorManager.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Spacer(),
                                  BlocBuilder<LocalizationCubit,LocalizationStates>(
                                    builder: (context,state){
                                      return GestureDetector(
                                        onTap: (){
                                          CashHelper.getData(key: CashHelper.languageKey).toString()=='en'?
                                          context.read<LocalizationCubit>().changeLanguage(code: 'ar'):
                                          context.read<LocalizationCubit>().changeLanguage(code: 'en');
                                        },
                                        child: Container(
                                            padding:EdgeInsets.symmetric(
                                              horizontal: MediaQuery.sizeOf(context).width*0.04,
                                              vertical: MediaQuery.sizeOf(context).width*0.01,
                                            ),
                                            decoration:BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(10),
                                            ) ,
                                            child:CashHelper.getData(key: CashHelper.languageKey).toString()=='en'?
                                            Text('English',style: TextStyles.textStyle18Bold.copyWith(
                                                color: ColorManager.black,
                                                fontSize:MediaQuery.sizeOf(context).height*0.018
                                            ),):
                                            Text('عربي',style: TextStyles.textStyle18Bold.copyWith(
                                                color: ColorManager.black,
                                                fontSize:MediaQuery.sizeOf(context).height*0.018
                                            ))
                                        ),
                                      );
                                    } ,
                                  ),

                                  Visibility(
                                    visible: UserDataFromStorage.userIsGuest == true? true:false,
                                    child: IconButton(
                                      onPressed: (){
                                        context.go(AppRouter.login);
                                      },
                                      icon: const Icon(Icons.login_outlined),color: ColorManager.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.height * 0.02,
                            ),
                            Container(
                              height: SizeConfig.height * 0.06,
                              width: SizeConfig.width,
                              decoration: BoxDecoration(
                                color: ColorManager.gray,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if(UserDataFromStorage.userIsGuest==false){
                                        await AuthCubit.get(context).getUserInfo(uId: UserDataFromStorage.uIdFromStorage,context: context);
                                        if(UserDataFromStorage.uIdFromStorage=='') {
                                          toastificationWidget(context: context,
                                              title: AppLocalizations.of(context)!.translate('errorOccurred').toString(),
                                              body: AppLocalizations.of(context)!.translate('deleteMessage').toString(),
                                              type: ToastificationType.error);
                                          context.go(AppRouter.login);

                                        }else{
                                          if(UserDataFromStorage.isUserBlocked==true){
                                            AuthCubit.get(context).logout();
                                            context.go(AppRouter.login);
                                            toastificationWidget(context: context,
                                                title: AppLocalizations.of(context)!.translate('blockOccurred').toString(),
                                                body: AppLocalizations.of(context)!.translate('blockMessage').toString(),
                                                type: ToastificationType.error);
                                          }else{
                                            cubit.changeActiveOrders(true);
                                          }
                                        }
                                      }else{
                                        cubit.changeActiveOrders(true);
                                      }
                                    },
                                    child: Container(
                                      height: SizeConfig.height * 0.06,
                                      width: SizeConfig.width*0.5,
                                      decoration: BoxDecoration(
                                        color: cubit.isActiveOrders?ColorManager.primaryBlue:ColorManager.gray,
                                        borderRadius: CashHelper.getData(key: CashHelper.languageKey).toString()=='en'?BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                        ):BorderRadius.only( topRight: Radius.circular(20)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.translate('activeOrders').toString(),
                                          style: TextStyles.textStyle18Medium.copyWith(color: ColorManager.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: ()async {
                                      if(UserDataFromStorage.userIsGuest==false){
                                        await AuthCubit.get(context).getUserInfo(uId: UserDataFromStorage.uIdFromStorage,context: context);
                                        if(UserDataFromStorage.uIdFromStorage==''){
                                          toastificationWidget(context: context,
                                              title: AppLocalizations.of(context)!.translate('errorOccurred').toString(),
                                              body: AppLocalizations.of(context)!.translate('deleteMessage').toString(),
                                              type: ToastificationType.error);
                                          context.go(AppRouter.login);
                                        }else{
                                          if(UserDataFromStorage.isUserBlocked==true){
                                            AuthCubit.get(context).logout();
                                            context.go(AppRouter.login);
                                            toastificationWidget(context: context,
                                                title: AppLocalizations.of(context)!.translate('blockOccurred').toString(),
                                                body: AppLocalizations.of(context)!.translate('blockMessage').toString(),
                                                type: ToastificationType.error);
                                          }else{
                                            cubit.changeActiveOrders(false);
                                          }
                                        }

                                      }else{
                                        cubit.changeActiveOrders(false);
                                      }

                                    },
                                    child: Container(
                                      height: SizeConfig.height * 0.06,
                                      width: SizeConfig.width*0.5,
                                      decoration: BoxDecoration(
                                        color: cubit.isActiveOrders?ColorManager.gray:ColorManager.primaryBlue,
                                        borderRadius: CashHelper.getData(key: CashHelper.languageKey).toString()=='en' ?BorderRadius.only(topRight: Radius.circular(20)):BorderRadius.only(
                                            topLeft: Radius.circular(20)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.translate('completedOrders').toString(),
                                          style: TextStyles.textStyle18Medium.copyWith(color: ColorManager.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                            /// banner carousel slider
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: SizeConfig.height * 0.02),
                              child: CarouselSlider(
                                items: cubit.banners.map((image) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                        onTap: ()async{
                                          cubit.lanuchToUrl(image.url);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 2),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width*0.9,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(SizeConfig.height * 0.02),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(SizeConfig.height * 0.02),
                                              child: CachedNetworkImage(
                                                imageUrl: image.image,
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) => const Center(
                                                  child: CupertinoActivityIndicator(),
                                                ),
                                                errorWidget: (context, url, error) => Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius: BorderRadius.circular(SizeConfig.height * 0.02),
                                                  ),
                                                  child: const Icon(Icons.error),
                                                ),
                                              )
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  autoPlay: true,
                                  height: 180,
                                  enableInfiniteScroll: false,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 1,
                                ),
                              ),
                            ),

                            /// search bar
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SearchBarWidget(
                                onChanged: (value)async {
                                  if(UserDataFromStorage.userIsGuest==false){
                                    await AuthCubit.get(context).getUserInfo(uId: UserDataFromStorage.uIdFromStorage,context: context);
                                    if(UserDataFromStorage.uIdFromStorage==''){
                                      toastificationWidget(context: context,
                                          title: AppLocalizations.of(context)!.translate('errorOccurred').toString(),
                                          body: AppLocalizations.of(context)!.translate('deleteMessage').toString(),
                                          type: ToastificationType.error);
                                      context.go(AppRouter.login);
                                    }else{
                                      if(UserDataFromStorage.isUserBlocked==true){
                                        AuthCubit.get(context).logout();
                                        context.go(AppRouter.login);
                                        toastificationWidget(context: context,
                                            title: AppLocalizations.of(context)!.translate('blockOccurred').toString(),
                                            body: AppLocalizations.of(context)!.translate('blockMessage').toString(),
                                            type: ToastificationType.error);
                                      }else{
                                        cubit.search(value);
                                      }
                                    }
                                  }else{
                                    cubit.search(value);
                                  }

                                },
                                searchController: cubit.searchController,
                              ),
                            ),

                            cubit.isActiveOrders? GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
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
                                    onTap: () async {
                                      if(UserDataFromStorage.userIsGuest==false){
                                        print('Uid ${UserDataFromStorage.uIdFromStorage}');
                                        await AuthCubit.get(context).getUserInfo(uId: UserDataFromStorage.uIdFromStorage,context: context);
                                        if(UserDataFromStorage.uIdFromStorage==''){
                                          toastificationWidget(context: context,
                                              title: AppLocalizations.of(context)!.translate('errorOccurred').toString(),
                                              body: AppLocalizations.of(context)!.translate('deleteMessage').toString(),
                                              type: ToastificationType.error);
                                          context.go(AppRouter.login);
                                        }else{
                                          if(UserDataFromStorage.isUserBlocked==true){
                                            context.go(AppRouter.login);
                                            toastificationWidget(context: context,
                                                title: AppLocalizations.of(context)!.translate('blockOccurred').toString(),
                                                body: AppLocalizations.of(context)!.translate('blockMessage').toString(),
                                                type: ToastificationType.error);
                                          }else{
                                            customPushNavigator(
                                              context,
                                              BlocProvider(
                                                create: (context) => VisitorsCubit(getIt()),
                                                child: OccasionDetails(
                                                  occasionId: cubit.activeOccasions[index].occasionId,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      }else{
                                        customPushNavigator(
                                          context,
                                          BlocProvider(
                                            create: (context) => VisitorsCubit(getIt()),
                                            child: OccasionDetails(
                                              occasionId: cubit.activeOccasions[index].occasionId,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: ActiveOccasionCard(
                                      occasionEntity: cubit.activeOccasions[index],
                                    ));
                              },
                              itemCount: cubit.activeOccasions.length,
                            ):  GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
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
                                    onTap: () {
                                    },
                                    child: OccasionCard(
                                      occasionEntity: cubit.doneOccasions[index],
                                    ));
                              },
                              itemCount: cubit.doneOccasions.length,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
                cubit.searchOccasionsList.isEmpty || cubit.searchController.text.trim().isEmpty? SizedBox(): Positioned(
                  top: mediaQuery.height * 0.22,
                  left:  mediaQuery.width * 0.05,
                  right:  mediaQuery.width * 0.05,
                  child: SearchResultContainer(),
                )
            ],
          ),

        );
      },
    );
  }
}


