import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/constants/app_constants.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

AppBar mainAppBarWidget({required String appBarTitle}) {
  return  AppBar(
    backgroundColor: ColorManager.gray,
    title: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        appBarTitle,
        style: TextStyles.textStyle18Bold.copyWith(
            color: ColorManager.primaryBlue
        ),
      ),
    ),
  );
}