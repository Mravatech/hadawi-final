import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingViewBody extends StatelessWidget {
  const SettingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthStates>(
      listener: (context, state) {
         if(state is UserLogoutSuccessState){
           context.go(AppRouter.login);
         }
         if(state is UserLogoutErrorState){
           customToast(title: state.message, color: ColorManager.error);
         }
         if(state is DeleteUserSuccessState){
           context.go(AppRouter.login);
         }
         if(state is DeleteUserErrorState){
           customToast(title: state.message, color: ColorManager.error);
         }
      },
      builder: (context, state) {
        var cubit = context.read<AuthCubit>();
        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).height*0.02
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment:  CrossAxisAlignment.center,
            children: [

              SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

              Container(
                height:  MediaQuery.sizeOf(context).height*0.07,
                decoration: BoxDecoration(
                  color: ColorManager.primaryBlue,
                  borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height*0.1),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorManager.white,
                      radius: MediaQuery.sizeOf(context).height*0.035,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image(
                            height: MediaQuery.sizeOf(context).height*0.12,
                            image: AssetImage(AssetsManager.logoWithoutBackground
                            )),
                      ),
                    ),
                    SizedBox(width: MediaQuery.sizeOf(context).height*0.02,),
                    Expanded(
                      child: Text(UserDataFromStorage.userNameFromStorage,style: TextStyles.textStyle18Bold.copyWith(
                          color: ColorManager.white
                      ),),
                    ),
                  ],
                ) ,
              ),

              SizedBox(height: MediaQuery.sizeOf(context).height*0.03,),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorManager.primaryBlue,
                ),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height*0.03,),

                    // اللغه
                    RowDataWidget(
                        image:AssetsManager.globalAccount,
                        title: AppLocalizations.of(context)!.translate('language').toString()
                        ,lang: true),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(color: ColorManager.white,),
                    ),

                    // الاشعارات
                    InkWell(
                      onTap: (){
                        // context.go(AppRouter.notification);
                        customPushNavigator(context, NotificationScreen());
                      },
                      child: RowDataWidget(
                          image:AssetsManager.notificationAccount,
                          title: AppLocalizations.of(context)!.translate('notification').toString(),
                          lang: false,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(color: ColorManager.white,),
                    ),

                    // الاشعارات
                    InkWell(
                      onTap: (){
                        customPushNavigator(context, PrivacyPoliciesScreen());
                      },
                      child: RowDataWidget(
                        image: AssetsManager.privacyPolices,
                        title: AppLocalizations.of(context)!.translate('privacyPolicies').toString(),
                        lang: false,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(color: ColorManager.white,),
                    ),

                    // تواصل معنا
                    GestureDetector(
                        onTap: (){
                          context.read<HomeCubit>().launchWhatsApp();
                        },
                        child: RowDataWidget(
                            image:AssetsManager.supportAccount,
                            title: AppLocalizations.of(context)!.translate('technicalSupport').toString(),
                            lang: false
                        )
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(color: ColorManager.white,),
                    ),

                    // حذف الحساب
                    GestureDetector(
                        onTap: (){
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("تحذير"),
                                content: Text("هل أنت متأكد أنك تريد حذف الحساب؟"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);// رفض
                                    },
                                    child: Text("إلغاء"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      cubit.deleteUser();
                                    },
                                    child: Text("حذف"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: RowDataWidget(
                            image:AssetsManager.deleteAccount,
                            title: AppLocalizations.of(context)!.translate('deleteAccount').toString(),
                            lang: false
                        )
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(color: ColorManager.white,),
                    ),

                    // Logout
                    GestureDetector(
                        onTap: ()=>cubit.logout(),
                        child: RowDataWidget(
                            image:AssetsManager.logoutAccount,
                            title: AppLocalizations.of(context)!.translate('logout').toString(),
                            lang: false)
                    ),

                    SizedBox(height: MediaQuery.sizeOf(context).height*0.03,),
                  ],
                ),
              )


            ],
          ),
        );
      },
    );
  }
}
