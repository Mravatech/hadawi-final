import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/widgets/forget_password_view_body.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/widgets/login_view_body.dart';
import 'package:hadawi_app/widgets/app_bar_without_height_widget.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:appBarWithoutHeightWidget(),
      body: ForgetPasswordViewBody(),
    );
  }
}
