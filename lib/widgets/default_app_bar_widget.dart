import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

PreferredSizeWidget defaultAppBarWidget({
  required String appBarTitle,
  required BuildContext context,
  bool isHomeLayout = false,
}) {
  return AppBar(
    elevation: 0,
    scrolledUnderElevation: 2,
    shadowColor: ColorManager.primaryBlue.withOpacity(0.1),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    titleSpacing: 0,
    leading: isHomeLayout
        ? null
        : Hero(
            tag: 'back_button',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                customBorder: CircleBorder(),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: ColorManager.darkGrey,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
    title: Row(
      children: [
        SizedBox(width: 16),
        Expanded(
          child: Text(
            appBarTitle,
            style: TextStyles.textStyle18Bold.copyWith(
              color: ColorManager.black,
              fontSize: isHomeLayout ? 24 : 20,
              letterSpacing: -0.5,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Hero(
            tag: 'app_logo',
            child: Image.asset(
              AssetsManager.logoWithoutBackground,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    ),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(1),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorManager.primaryBlue.withOpacity(0.05),
              ColorManager.primaryBlue.withOpacity(0.1),
              ColorManager.primaryBlue.withOpacity(0.05),
            ],
          ),
        ),
      ),
    ),
  );
}
