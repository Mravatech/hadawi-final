import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

AppBar defaultAppBarWidget({required String appBarTitle}) {
  return AppBar(
      toolbarHeight: SizeConfig.height*0.12,
      backgroundColor: ColorManager.gray,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image(
              height: SizeConfig.height*0.1,
              image: AssetImage(AssetsManager.logoWithoutBackground
              )
          ),
          SizedBox(width: SizeConfig.width*0.1,),
          Expanded(
            child: Text(
              textAlign: TextAlign.center,
              appBarTitle, style: TextStyles.textStyle24Bold.copyWith(
                color: ColorManager.darkGrey
            ),),
          ),
        ],
      ),
  );
}
