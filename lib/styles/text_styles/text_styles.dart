
import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';


class TextStyles {
  /// normal text style
  static TextStyle textStyle12Bold= TextStyle(
      fontSize: SizeConfig.height * 0.015,
      color: ColorManager.white,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.bold
  );

  static TextStyle textStyle12Medium= TextStyle(
      fontSize: SizeConfig.height * 0.015,
      color: ColorManager.white,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w600
  );

  static TextStyle textStyle12Regular= TextStyle(
      fontSize: SizeConfig.height * 0.015,
      color: ColorManager.white,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w400
  );


  /// normal text style
  static TextStyle textStyle18Bold= TextStyle(
    fontSize: SizeConfig.height * 0.02,
    color: ColorManager.white,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.bold
  );

  static TextStyle textStyle18Medium= TextStyle(
      fontSize: SizeConfig.height * 0.02,
      color: ColorManager.white,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w500
  );

  static TextStyle textStyle18Regular= TextStyle(
      fontSize: SizeConfig.height * 0.02,
      color: ColorManager.white,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w500
  );

  /// medium text style
  static TextStyle textStyle24Bold= TextStyle(
      fontSize: SizeConfig.height * 0.024,
      color: ColorManager.white,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.bold
  );

  static TextStyle textStyle24Medium= TextStyle(
      fontSize: SizeConfig.height * 0.024,
      color: ColorManager.white,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w600
  );

  static TextStyle textStyle24Regular= TextStyle(
      fontSize: SizeConfig.height * 0.024,
      color: ColorManager.white,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w500
  );

  /// large text style
  static TextStyle textStyle30Bold= TextStyle(
      fontSize: SizeConfig.height * 0.06,
      color: ColorManager.white,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.bold,
  );

  static TextStyle textStyle30Medium= TextStyle(
      fontSize: SizeConfig.height * 0.06,
      color: ColorManager.white,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w500
  );

  static TextStyle textStyle30Regular= TextStyle(
      fontSize: SizeConfig.height * 0.06,
      color: ColorManager.white,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w500
  );
}

