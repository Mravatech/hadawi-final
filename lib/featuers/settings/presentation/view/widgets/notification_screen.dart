import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/occasion_qr.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        final mediaQuery = MediaQuery.sizeOf(context);
        return ModalProgressHUD(
          inAsyncCall: state is GetUserNotificationsLoadingState ? true : false,
          child: Scaffold(
            backgroundColor: ColorManager.white,
            appBar: AppBar(
                backgroundColor: ColorManager.gray,
                leading: IconButton(
                    onPressed: (){
                      customPushAndRemoveUntil(context, HomeLayout());
                    }, icon: Icon(Icons.arrow_back)),
                title: Text(
                  AppLocalizations.of(context)!.translate('notification').toString(),
                  style: TextStyles.textStyle18Bold.copyWith(
                      color: ColorManager.black),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                        image: AssetImage(AssetsManager.logoWithoutBackground)),
                  ),

                ]),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: mediaQuery.width * 0.03),
              child: cubit.notifications.isNotEmpty ?ListView.separated(
                physics: BouncingScrollPhysics(),
                  itemBuilder: (context,index){
                  final notificationItem = cubit.notifications[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width * 0.03,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorManager.white,
                          borderRadius: BorderRadius.circular(SizeConfig.height * 0.02),
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.gray.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.height * 0.02),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: mediaQuery.height * 0.03,
                                    backgroundImage: AssetImage(AssetsManager.logoWithoutBackground),
                                  ),
                                  SizedBox(width: mediaQuery.width * 0.02,),
                                  Expanded(
                                    child: Text( notificationItem.message, style: TextStyles.textStyle18Medium.copyWith(
                                        color: ColorManager.black
                                    ),),
                                  ),
                                  Text(
                                    DateFormat('EEEE, d MMM y').format(DateTime.parse(notificationItem.date)), style: TextStyles.textStyle10Medium.copyWith(
                                      color: ColorManager.black
                                  ),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context,index)=>SizedBox(height: mediaQuery.height * 0.01,),
                  itemCount: cubit.notifications.length,
              ):Center(
                child: Text(
                  AppLocalizations.of(context)!.translate('no_notification').toString(),
                  style: TextStyles.textStyle18Bold.copyWith(
                    color: ColorManager.black
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
