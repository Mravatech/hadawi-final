import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Align(
          alignment: Alignment.topRight,
          child: Text(AppLocalizations.of(context)!.translate('forgetPassword').toString(),style: TextStyles.textStyle18Bold.copyWith(
              color: ColorManager.darkGrey,
              fontSize: MediaQuery.sizeOf(context).height*0.018
          ))
      ),
    );
  }
}
