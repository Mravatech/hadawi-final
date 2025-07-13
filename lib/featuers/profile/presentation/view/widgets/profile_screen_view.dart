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
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/controller/edit_profile_cubit.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/my_occasions_list.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';

class ProfileBodyView extends StatelessWidget {
  const ProfileBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionsListCubit, OccasionsListStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          color: Color(0xFFF8F7FB),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF0EEF5),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person_outline_rounded,
                            size: 70,
                            color: Color(0xFF8B7BA8).withOpacity(0.7),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        UserDataFromStorage.userNameFromStorage,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8B7BA8),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Options
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildProfileItem(
                        context,
                        icon: AssetsManager.userIcon,
                        title: AppLocalizations.of(context)!.translate('info').toString(),
                        onTap: () => customPushNavigator(
                          context,
                          BlocProvider(
                            create: (context) => EditProfileCubit(editProfileUseCases: getIt()),
                            child: EditProfileScreen(),
                          ),
                        ),
                      ),
                      _buildDivider(),
                      _buildProfileItem(
                        context,
                        icon: AssetsManager.balloonsIcon,
                        title: AppLocalizations.of(context)!.translate('occasionsList').toString(),
                        onTap: () => customPushNavigator(context, AllOccasionsScreen()),
                      ),
                      _buildDivider(),
                      _buildProfileItem(
                        context,
                        icon: AssetsManager.friendsIcon,
                        title: AppLocalizations.of(context)!.translate('friendsList').toString(),
                        onTap: () => customPushNavigator(context, FriendsScreen()),
                      ),
                    ],
                  ),
                ),

                // Secondary Options
                Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildProfileItem(
                        context,
                        icon: AssetsManager.requestAccount,
                        title: AppLocalizations.of(context)!.translate('myRequests').toString(),
                        onTap: () => customPushNavigator(context, MyOrdersWidgets()),
                      ),
                      _buildDivider(),
                      _buildProfileItem(
                        context,
                        icon: 'assets/images/investor.png',
                        title: AppLocalizations.of(context)!.translate('sharedGifts').toString(),
                        onTap: () => customPushNavigator(context, MyOccasionsList()),
                      ),
                      _buildDivider(),
                      _buildProfileItem(
                        context,
                        icon: AssetsManager.moneyAccount,
                        title: AppLocalizations.of(context)!.translate('myContributions').toString(),
                        onTap: () => customPushNavigator(context, MyMoneyWidget()),
                      ),
                    ],
                  ),
                ),

                // Privacy Toggle
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('privateUser').toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8B7BA8),
                        ),
                      ),
                      Switch(
                        value: OccasionsListCubit.get(context).privateAccount,
                        onChanged: (bool value) => OccasionsListCubit.get(context).changePrivateAccount(),
                        activeColor: Color(0xFF8B7BA8),
                        activeTrackColor: Color(0xFFF0EEF5),
                        inactiveThumbColor: Colors.grey[400],
                        inactiveTrackColor: Colors.grey[200],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFF0EEF5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                icon,
                color: Color(0xFF8B7BA8),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF0EEF5),
      indent: 76,
      endIndent: 20,
    );
  }
}
