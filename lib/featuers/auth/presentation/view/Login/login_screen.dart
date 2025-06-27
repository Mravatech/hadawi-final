import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/widgets/login_view_body.dart';
import 'package:hadawi_app/widgets/app_bar_without_height_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:appBarWithoutHeightWidget(),
      body: LoginViewBody(),
    );
  }
}
