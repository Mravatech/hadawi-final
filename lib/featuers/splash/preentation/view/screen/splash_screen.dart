import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/splash/preentation/view/widgets/splash_body_view.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: ColorManager.primaryBlue,
        padding: EdgeInsets.zero,
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: const SplashBodyView(),
      ),
    );
  }
}
