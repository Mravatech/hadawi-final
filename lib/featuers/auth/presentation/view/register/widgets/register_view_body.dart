import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/register_form_widget.dart';
import 'package:hadawi_app/widgets/login_widget.dart';

class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key});

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {

  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    passController.dispose();
    phoneController.dispose();
    nameController.dispose();
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
          flex: 5,
          child: RegisterFormWidget(
            phoneController:  phoneController,
            passController:  passController,
            nameController:  nameController,
          ),
        ),

      ],
    );
  }
}
