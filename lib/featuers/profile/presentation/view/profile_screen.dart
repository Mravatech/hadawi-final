import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/profile_screen_view.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: ProfileBodyView(),
    );
  }
}
