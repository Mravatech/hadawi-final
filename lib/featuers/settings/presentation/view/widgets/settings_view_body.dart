import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/row_data_widget.dart';
import 'package:hadawi_app/featuers/settings/presentation/view/widgets/notification_screen.dart';
import 'package:hadawi_app/featuers/settings/presentation/view/widgets/privacy_policies.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/localiztion/localization_cubit.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingViewBody extends StatelessWidget {
  const SettingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is UserLogoutSuccessState) {
          customPushReplacement(context, LoginScreen());
        }
        if (state is UserLogoutErrorState) {
          customToast(title: state.message, color: ColorManager.error);
        }
        if (state is DeleteUserSuccessState) {
          customPushReplacement(context, LoginScreen());
        }
        if (state is DeleteUserErrorState) {
          customPushAndRemoveUntil(context, LoginScreen());
        }
      },
      builder: (context, state) {
        var cubit = context.read<AuthCubit>();
        return Container(
          color: Color(0xFFF8F7FB),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  margin: EdgeInsets.all(20),
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
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF0EEF5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            AssetsManager.logoWithoutBackground,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UserDataFromStorage.userNameFromStorage,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF8B7BA8),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context)!.translate('settings').toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Settings Options
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
                      _buildSettingItem(
                        context,
                        icon: AssetsManager.globalAccount,
                        title: AppLocalizations.of(context)!.translate('language').toString(),
                        isLanguage: true,
                        onTap: () {
                          final currentLang = CashHelper.getData(key: CashHelper.languageKey).toString();
                          context.read<LocalizationCubit>().changeLanguage(
                            code: currentLang == 'en' ? 'ar' : 'en'
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingItem(
                        context,
                        icon: AssetsManager.notificationAccount,
                        title: AppLocalizations.of(context)!.translate('notification').toString(),
                        onTap: () => customPushNavigator(context, NotificationScreen()),
                      ),
                      _buildDivider(),
                      _buildSettingItem(
                        context,
                        icon: AssetsManager.privacyPolices,
                        title: AppLocalizations.of(context)!.translate('privacyPolicies').toString(),
                        onTap: () => customPushNavigator(context, PrivacyPoliciesScreen()),
                      ),
                      _buildDivider(),
                      _buildSettingItem(
                        context,
                        icon: AssetsManager.supportAccount,
                        title: AppLocalizations.of(context)!.translate('technicalSupport').toString(),
                        onTap: () => context.read<HomeCubit>().launchWhatsApp(),
                      ),
                    ],
                  ),
                ),

                // Account Actions
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
                      _buildSettingItem(
                        context,
                        icon: AssetsManager.deleteAccount,
                        title: AppLocalizations.of(context)!.translate('deleteAccount').toString(),
                        textColor: Colors.red,
                        onTap: () => _showDeleteAccountDialog(context, cubit),
                      ),
                      _buildDivider(),
                      _buildSettingItem(
                        context,
                        icon: AssetsManager.logoutAccount,
                        title: AppLocalizations.of(context)!.translate('logout').toString(),
                        textColor: Color(0xFF8B7BA8),
                        onTap: () => cubit.logout(),
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

  Widget _buildSettingItem(
    BuildContext context, {
    required String icon,
    required String title,
    bool isLanguage = false,
    Color? textColor,
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
                  color: textColor ?? Colors.black87,
                ),
              ),
            ),
            if (isLanguage) ...[
              Text(
                Localizations.localeOf(context).languageCode == 'en' ? 'English' : 'العربية',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
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

  void _showDeleteAccountDialog(BuildContext context, AuthCubit cubit) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            AppLocalizations.of(context)!.translate('warning').toString(),
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.translate('deleteAccountConfirmation').toString(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context)!.translate('cancel').toString(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                cubit.deleteUser();
              },
              child: Text(
                AppLocalizations.of(context)!.translate('delete').toString(),
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
