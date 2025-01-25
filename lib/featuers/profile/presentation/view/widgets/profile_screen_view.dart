import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/all_occasions/presentation/view/all_occasions_screen.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/screens/edit_personal_info.dart';
import 'package:hadawi_app/featuers/friends/presentation/view/friends_screen.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/row_data_widget.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/switch_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';

class ProfileBodyView extends StatelessWidget {
  const ProfileBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [

           SizedBox(height: MediaQuery.sizeOf(context).height*0.05,),

           // البيانات الشخصية
           GestureDetector(
               onTap:  (){
                 customPushNavigator(context, EditProfileScreen());
               },
               child: RowDataWidget(image: AssetsManager.userIcon, title: 'البيانات الشخصية',)
           ),

           SizedBox(height: MediaQuery.sizeOf(context).height*0.035,),

           // قائمة المناسبات
           GestureDetector(
               onTap: (){
                 customPushNavigator(context, AllOccasionsScreen());
             },
               child: RowDataWidget(
                 image: AssetsManager.balloonsIcon,
                 title: 'قائمة المناسبات',
               )
           ),

           SizedBox(height: MediaQuery.sizeOf(context).height*0.035,),

           // قائمة الاصدقاء
           GestureDetector(
               onTap: (){
                 customPushNavigator(context, FriendsScreen());
               },
               child: RowDataWidget(
                 image: AssetsManager.friendsIcon,
                 title: 'قائمة الاصدقاء',
               )
           ),

           SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

           Text('حساب خاص',style: TextStyles.textStyle24Bold.copyWith(
             fontSize: MediaQuery.sizeOf(context).height*0.03
           ),),

           SizedBox(height: MediaQuery.sizeOf(context).height*0.01,),

           SwitchWidget(),

         ],
       ),
    );
  }
}
