import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.gray,
      ),
      alignment: Alignment.center,
      height: MediaQuery.sizeOf(context).height*0.2,
      child: Image(
        height:  MediaQuery.sizeOf(context).height*0.1,
        image: AssetImage(AssetsManager.logoWithoutBackground),
      ),
    );
  }
}
