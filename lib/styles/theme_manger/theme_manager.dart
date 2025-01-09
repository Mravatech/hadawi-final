import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';

ThemeData getApplicationTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: ColorManager.white,
    primaryColor: ColorManager.primaryBlue,
    useMaterial3: true,
    fontFamily: 'Cairo',
    // app bar theme
    appBarTheme: AppBarTheme(
        color: ColorManager.white,
        titleTextStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: ColorManager.backgroundText,
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.sizeOf(context).height*.025,
          fontFamily: 'Cairo',
        ),
        iconTheme: const IconThemeData(
          color: ColorManager.black,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        )),
  );
}