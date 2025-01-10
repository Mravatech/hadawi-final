import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/register_view_body.dart';
import 'package:hadawi_app/widgets/app_bar_without_height_widget.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithoutHeightWidget(),
      body: RegisterViewBody()
    );
  }
}
