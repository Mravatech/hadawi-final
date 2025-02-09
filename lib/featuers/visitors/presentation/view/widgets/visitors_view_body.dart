import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_card.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_details.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/search_bar_widget.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/search_result_container.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/visitors_home_shimmer.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/localiztion/localization_cubit.dart';
import 'package:hadawi_app/utiles/localiztion/localization_states.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../styles/colors/color_manager.dart';
import '../../../../../utiles/shared_preferences/shared_preference.dart';

class VisitorsViewBody extends StatelessWidget {
  const VisitorsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitorsCubit, VisitorsState>(
      builder: (context, state) {
        final mediaQuery = MediaQuery.sizeOf(context);
        final cubit = context.read<VisitorsCubit>();
        return ModalProgressHUD(
          inAsyncCall: state is GetOccasionsLoadingState,
          progressIndicator: VisitorsHomeShimmer(),
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
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://img.freepik.com/free-photo/watercolor-gift-card-illustration_23-2151912036.jpg?t=st=1737894355~exp=1737897955~hmac=c642672a986fba67b3321c10c3db7e2e39f2faef06d8faa677b7e5871b097aa6&w=360'),
                              opacity: .3),
                        ),
                        height: mediaQuery.height * 0.19,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: mediaQuery.height * 0.03,
                            horizontal: mediaQuery.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                            Visibility(
                              visible: UserDataFromStorage.userIsGuest == true? true:false,
                              child: Row(
                                children: [
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
                                  IconButton(
                                    onPressed: (){
                                      customPushAndRemoveUntil(context, LoginScreen());
                                    },
                                    icon: const Icon(Icons.login_outlined),color: ColorManager.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SearchBarWidget(
                      onChanged: (value) {
                        cubit.search(value);
                      },
                      searchController: cubit.searchController,
                    ),
                  ),

                  SizedBox(height: mediaQuery.height * 0.01,),

                  state is GetOccasionsLoadingState ? Container():Container(
                    height: SizeConfig.height * 0.05,
                    width: SizeConfig.width * 0.9,
                    decoration: BoxDecoration(
                      color: ColorManager.gray,
                      borderRadius: BorderRadius.circular(SizeConfig.height * 0.2),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            cubit.changeActiveOrders(true);
                          },
                          child: Container(
                            height: SizeConfig.height * 0.05,
                            width: SizeConfig.width*0.45,
                            decoration: BoxDecoration(
                              color: cubit.isActiveOrders?ColorManager.primaryBlue:ColorManager.gray,
                              borderRadius: BorderRadius.circular(SizeConfig.height * 0.2),
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
                          onTap: () {
                            cubit.changeActiveOrders(false);
                          },
                          child: Container(
                            height: SizeConfig.height * 0.05,
                            width: SizeConfig.width*0.45,
                            decoration: BoxDecoration(
                              color: cubit.isActiveOrders?ColorManager.gray:ColorManager.primaryBlue,
                              borderRadius: BorderRadius.circular(SizeConfig.height * 0.2),
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

                  SizedBox(
                    height: SizeConfig.height * 0.02
                  ),

                  cubit.isActiveOrders? Expanded(
                    child: GridView.builder(
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
                              customPushNavigator(
                                  context,
                                  BlocProvider(
                                    create: (context) => VisitorsCubit(getIt()),
                                    child: OccasionDetails(
                                      occasionEntity: cubit.activeOccasions[index],
                                    ),
                                  ),
                              );
                            },
                            child: OccasionCard(
                              occasionEntity: cubit.activeOccasions[index],
                            ));
                      },
                      itemCount: cubit.activeOccasions.length,
                    ),
                  ):  Expanded(
                    child: GridView.builder(
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
                              customPushNavigator(
                                context,
                                BlocProvider(
                                  create: (context) => VisitorsCubit(getIt()),
                                  child: OccasionDetails(
                                    occasionEntity: cubit.doneOccasions[index],
                                  ),
                                ),
                              );
                            },
                            child: OccasionCard(
                              occasionEntity: cubit.doneOccasions[index],
                            ));
                      },
                      itemCount: cubit.doneOccasions.length,
                    ),
                  )
                ],
              ),
             cubit.searchOccasionsList.isEmpty || cubit.searchController.text.trim().isEmpty? SizedBox(): Positioned(
              top: mediaQuery.height * 0.22,
              left:  mediaQuery.width * 0.05,
              right:  mediaQuery.width * 0.05,
              child: SearchResultContainer())
            ],
          ),
        );
      },
    );
  }
}
