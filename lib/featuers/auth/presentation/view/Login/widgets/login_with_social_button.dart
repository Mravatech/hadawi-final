import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/widgets/default_button_with_image.dart';

class LoginWithSocialButton extends StatelessWidget {
  const LoginWithSocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DefaultButtonWithImage(
            image:AssetsManager.googleIcon ,
            buttonText: 'Continue with',
            onTap: (){},
          ),
        ),
        SizedBox( width:  MediaQuery.sizeOf(context).height*0.02,),
        Expanded(
          child: DefaultButtonWithImage(
            image:AssetsManager.appleIcon ,
            buttonText: 'Continue with',
            onTap: (){},
          ),
        ),
      ],
    );
  }
}
