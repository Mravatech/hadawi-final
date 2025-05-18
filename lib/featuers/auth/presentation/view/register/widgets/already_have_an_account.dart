import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import '../../../../../../utiles/helper/material_navigation.dart';

class AlreadyHaveAnAccount extends StatelessWidget {
  const AlreadyHaveAnAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.translate('haveAccount').toString(),
            style: TextStyles.textStyle18Bold.copyWith(
            color: ColorManager.darkGrey,
            fontSize: MediaQuery.sizeOf(context).height*0.018
        )),
        GestureDetector(
          onTap: ()=> customPushReplacement(context, LoginScreen()),
          child: Text(AppLocalizations.of(context)!.translate('login').toString(),
              style: TextStyles.textStyle18Bold.copyWith(
              color: ColorManager.primaryBlue,
              fontSize: MediaQuery.sizeOf(context).height*0.02
          )),
        ),


      ],
    );
  }
}
