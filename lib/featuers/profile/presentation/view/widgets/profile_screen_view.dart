import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/all_occasions/presentation/view/all_occasions_screen.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/screens/edit_personal_info.dart';
import 'package:hadawi_app/featuers/friends/presentation/view/friends_screen.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_cubit.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_states.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/my_gifts_widget.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/my_money_widget.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/my_orders_widgets.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/profile_row_widget.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/row_data_widget.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/switch_widget.dart';
import 'package:hadawi_app/featuers/splash/preentation/view/widgets/logo_image.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';

import '../../../../../utiles/services/service_locator.dart';
import '../../../../edit_personal_info/view/controller/edit_profile_cubit.dart';
import '../../../../payment_page/presentation/view/my_occasions_list.dart';

class ProfileBodyView extends StatelessWidget {
  const ProfileBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionsListCubit, OccasionsListStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).height * 0.02,
                vertical: MediaQuery.sizeOf(context).height * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),

                // البيانات الشخصية
                GestureDetector(
                    onTap: () {
                      customPushNavigator(
                          context,
                          BlocProvider(
                            create: (context) => EditProfileCubit(editProfileUseCases: getIt()),
                            child: EditProfileScreen(),
                          ));
                    },
                    child: ProfileRowWidget(
                        image: AssetsManager.userIcon,
                        title: AppLocalizations.of(context)!
                            .translate('info')
                            .toString())),

                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.035,
                ),

                // قائمة المناسبات
                GestureDetector(
                    onTap: () {
                      customPushNavigator(context, AllOccasionsScreen());
                    },
                    child: ProfileRowWidget(
                        image: AssetsManager.balloonsIcon,
                        title: AppLocalizations.of(context)!
                            .translate('occasionsList')
                            .toString())),

                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.035,
                ),

                // قائمة الاصدقاء
                GestureDetector(
                    onTap: () {
                      customPushNavigator(context, FriendsScreen());
                    },
                    child: ProfileRowWidget(
                        image: AssetsManager.friendsIcon,
                        title: AppLocalizations.of(context)!
                            .translate('friendsList')
                            .toString())),

                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),

                // طلباتي
                GestureDetector(
                    onTap: () {
                      customPushNavigator(context, MyOrdersWidgets());
                    },
                    child: ProfileRowWidget(
                        image: AssetsManager.requestAccount,
                        title: AppLocalizations.of(context)!
                            .translate('myRequests')
                            .toString())),

                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                // الاصدقاء المشاركين بهديتي
                InkWell(
                    onTap: (){
                      customPushNavigator(context, MyOccasionsList());
                    },
                    child: ProfileRowWidget(image: 'assets/images/investor.png', title: AppLocalizations.of(context)!.translate('sharedGifts').toString(),)),
                // // هداياي
                // GestureDetector(
                //     onTap: () {
                //       customPushNavigator(context, MyGiftsWidget());
                //     },
                //     child: ProfileRowWidget(
                //         image: AssetsManager.giftAccount,
                //         title: AppLocalizations.of(context)!
                //             .translate('myGifts')
                //             .toString())),

                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),

                // المساهمات
                GestureDetector(
                    onTap: () {
                      customPushNavigator(context, MyMoneyWidget());
                    },
                    child: ProfileRowWidget(
                        image: AssetsManager.moneyAccount,
                        title: AppLocalizations.of(context)!
                            .translate('myContributions')
                            .toString())),

                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),

                // private user
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .translate('privateUser')
                          .toString(),
                      style: TextStyles.textStyle18Bold.copyWith(
                          color: ColorManager.primaryBlue, fontSize: 16),
                    ),
                    Switch(
                      inactiveThumbColor: ColorManager.gray,
                      inactiveTrackColor: ColorManager.white.withOpacity(0.6),
                      activeTrackColor:
                      ColorManager.primaryBlue.withOpacity(0.8),
                      activeColor: ColorManager.white,
                      value: OccasionsListCubit.get(context).privateAccount,
                      onChanged: (bool value) => OccasionsListCubit.get(context)
                          .changePrivateAccount(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
