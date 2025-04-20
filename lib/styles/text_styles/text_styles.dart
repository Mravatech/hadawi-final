
import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';


class TextStyles {
  /// small text style
  static TextStyle textStyle12Bold= TextStyle(
      fontSize: SizeConfig.height * 0.014,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.bold
  );

  static TextStyle textStyle12Medium= TextStyle(
      fontSize: SizeConfig.height * 0.014,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.w600
  );

  static TextStyle textStyle12Regular= TextStyle(
      fontSize: SizeConfig.height * 0.014,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.w400
  );

  static TextStyle textStyle10Bold= TextStyle(
      fontSize: SizeConfig.height * 0.011,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.bold
  );

  static TextStyle textStyle10Medium= TextStyle(
      fontSize: SizeConfig.height * 0.011,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.w600
  );

  static TextStyle textStyle10Regular= TextStyle(
      fontSize: SizeConfig.height * 0.011,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.w400
  );


  static TextStyle textStyle16Bold= TextStyle(
      fontSize: SizeConfig.height * 0.016,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.bold
  );

  static TextStyle textStyle16Medium= TextStyle(
      fontSize: SizeConfig.height * 0.016,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.w600
  );

  static TextStyle textStyle16Regular= TextStyle(
      fontSize: SizeConfig.height * 0.016,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.w400
  );

  /// normal text style
  static TextStyle textStyle18Bold= TextStyle(
    fontSize: SizeConfig.height * 0.017,
    color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.bold
  );

  static TextStyle textStyle18Medium= TextStyle(
      fontSize: SizeConfig.height * 0.017,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.w500
  );

  static TextStyle textStyle18Regular= TextStyle(
      fontSize: SizeConfig.height * 0.017,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.w500
  );

  /// medium text style
  static TextStyle textStyle24Bold= TextStyle(
      fontSize: SizeConfig.height * 0.03,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.bold
  );

  static TextStyle textStyle24Medium= TextStyle(
      fontSize: SizeConfig.height * 0.03,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.w600
  );

  static TextStyle textStyle24Regular= TextStyle(
      fontSize: SizeConfig.height * 0.03,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.w500
  );

  /// large text style
  static TextStyle textStyle30Bold= TextStyle(
      fontSize: SizeConfig.height * 0.055,
      color: ColorManager.black,
    fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
    fontWeight: FontWeight.bold,
  );

  static TextStyle textStyle30Medium= TextStyle(
      fontSize: SizeConfig.height * 0.055,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.w500
  );

  static TextStyle textStyle30Regular= TextStyle(
      fontSize: SizeConfig.height * 0.055,
      color: ColorManager.black,
      fontFamily: CashHelper.getData(key: CashHelper.languageKey).toString() =='en'? 'NanumGothic' : 'Cairo',
      fontWeight: FontWeight.w500
  );
}

