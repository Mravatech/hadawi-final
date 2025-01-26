import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/row_data_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';

class SettingViewBody extends StatelessWidget {
  const SettingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: Image(
                      height: MediaQuery.sizeOf(context).height*0.12,
                      image: AssetImage(AssetsManager.logoWithoutBackground
                      )),
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
                SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

                // اللغه
                RowDataWidget(image:AssetsManager.globalAccount, title: 'Language',lang: true),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(color: ColorManager.white,),
                ),

                // الاشعارات
                RowDataWidget(image:AssetsManager.notificationAccount, title: 'Notifications',lang: false),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(color: ColorManager.white,),
                ),

                // تواصل معنا
                RowDataWidget(image:AssetsManager.supportAccount, title: 'Technical Support',lang: false),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(color: ColorManager.white,),
                ),

                // حذف الحساب
                RowDataWidget(image:AssetsManager.deleteAccount, title: 'Delete Account',lang: false),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(color: ColorManager.white,),
                ),

                // Logout
                BlocBuilder<AuthCubit,AuthStates>(
                  builder: (context, state) {
                    var cubit = context.read<AuthCubit>();
                    return GestureDetector(
                        onTap: ()=>cubit.logout(),
                        child: RowDataWidget(image:AssetsManager.logoutAccount, title: 'Logout',lang: false)
                    );
                  },
                ),

                SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),
              ],
            ),
          )


        ],
      ),
    );
  }
}
