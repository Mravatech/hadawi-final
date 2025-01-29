import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

AppBar defaultAppBarWidget({required String appBarTitle}) {
  return AppBar(
      toolbarHeight: SizeConfig.height*0.12,
      backgroundColor: ColorManager.gray,
      titleSpacing: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width:  SizeConfig.height*0.02,),
          Text(
            appBarTitle, style: TextStyles.textStyle18Bold.copyWith(
              color: ColorManager.darkGrey
          ),),
          Spacer(),
          Image(
              height: SizeConfig.height*0.05,
              image: AssetImage(AssetsManager.logoWithoutBackground
              )
          ),

          SizedBox(width:  SizeConfig.height*0.02,)

        ],
      ),
  );
}
