import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/friends/presentation/controller/friends_cubit.dart';
import 'package:hadawi_app/featuers/friends/presentation/view/followers_screen.dart';
import 'package:hadawi_app/featuers/friends/presentation/view/following_request_screen.dart';
import 'package:hadawi_app/featuers/friends/presentation/view/following_screen.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/my_occasions_list.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/profile_row_widget.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/row_data_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';

class FriendsViewBody extends StatelessWidget {
  const FriendsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [

          SizedBox(height: MediaQuery.sizeOf(context).height*0.07,),

          // اصدقاء اتابعهم
          GestureDetector(
              onTap: ()=>customPushNavigator(context,
                  BlocProvider(create:(context) => FriendsCubit(getIt(),getIt(),getIt(),getIt(),),
                      child: FollowersScreen())),
              child: ProfileRowWidget(image: '',
                  title: AppLocalizations.of(context)!.translate('friendsIFollow').toString())
          ),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

          // الاصدقاء يتابعوني
          GestureDetector(
              onTap: ()=>customPushNavigator(context,
                  BlocProvider(create:(context) => FriendsCubit(getIt(),getIt(),getIt(),getIt(),),
                      child: FollowingScreen())),
              child: ProfileRowWidget(image: '', title:  AppLocalizations.of(context)!.translate('friendsFollowMe').toString(),)
          ),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

          // طلبات الصداقه
          GestureDetector(
              onTap: ()=>customPushNavigator(context,
                  BlocProvider(create:(context) => FriendsCubit(getIt(),getIt(),getIt(),getIt(),),
                  child: FollowingRequestScreen())),
              child: ProfileRowWidget(image: '', title: AppLocalizations.of(context)!.translate('followRequests').toString(),)
          ),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

          // الاصدقاء المشاركين بهديتي
          InkWell(
              onTap: (){
                customPushNavigator(context, MyOccasionsList());
              },
              child: ProfileRowWidget(image: '', title: AppLocalizations.of(context)!.translate('sharedGifts').toString(),,)),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

          // دعوه اصدقاء
          ProfileRowWidget(image: '', title: AppLocalizations.of(context)!.translate('inviteFriends').toString()),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

        ],
      ),
    );
  }
}
