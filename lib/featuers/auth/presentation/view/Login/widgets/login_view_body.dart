
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/widgets/login_form_widget.dart';
import 'package:hadawi_app/widgets/login_widget.dart';


class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {

  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    passController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: LogoWidget()
        ),

        Expanded(
          flex: 4,
          child: LoginFormWidget(
            passController: passController,
            phoneController: phoneController,
          ),
        ),

      ],
    );
  }
}
