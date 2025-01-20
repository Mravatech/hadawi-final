
import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.center,
      child: Image(
        width: MediaQuery.sizeOf(context).width*5,
        height: MediaQuery.sizeOf(context).height*.2,
        fit: BoxFit.contain,
        image:  AssetImage(
              AssetsManager.darkLogo
        ),
      ),
    );
  }
}