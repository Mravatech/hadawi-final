import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/all_occasions/presentation/view/all_occasions_screen.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/screens/edit_personal_info.dart';
import 'package:hadawi_app/featuers/friends/presentation/view/friends_screen.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/profile_row_widget.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/row_data_widget.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/switch_widget.dart';
import 'package:hadawi_app/featuers/splash/preentation/view/widgets/logo_image.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';

class ProfileBodyView extends StatelessWidget {
  const ProfileBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width:  MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      margin:  EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).height*0.02,
          vertical: MediaQuery.sizeOf(context).height*0.02
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

          Image(
            image: AssetImage(AssetsManager.logoWithoutBackground),
            height: MediaQuery.sizeOf(context).height*0.11,
            width: MediaQuery.sizeOf(context).height*0.11,
          ),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.035,),

          // البيانات الشخصية
          GestureDetector(
              onTap:  (){
                customPushNavigator(context, EditProfileScreen());
              },
              child: ProfileRowWidget(
                  image: AssetsManager.userIcon,
                  title: AppLocalizations.of(context)!.translate('info').toString()
              )
          ),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.035,),

          // قائمة المناسبات
          GestureDetector(
              onTap: (){
                customPushNavigator(context, AllOccasionsScreen());
              },
              child: ProfileRowWidget(
                  image: AssetsManager.balloonsIcon,
                  title: AppLocalizations.of(context)!.translate('occasionsList').toString()
              )
          ),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.035,),

          // قائمة الاصدقاء
          GestureDetector(
              onTap: (){
                customPushNavigator(context, FriendsScreen());
              },
              child: ProfileRowWidget(
                  image: AssetsManager.friendsIcon,
                  title: AppLocalizations.of(context)!.translate('friendsList').toString()
              )
          ),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),
        ],
      ),
    );

  }
}
