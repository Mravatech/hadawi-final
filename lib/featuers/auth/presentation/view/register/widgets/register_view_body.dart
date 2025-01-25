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
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    nameController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Align(
          alignment: AlignmentDirectional.bottomStart,
          child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: ()=>Navigator.pop(context),
              icon: Icon(Icons.arrow_back)
          ),
        ),

        Expanded(
            flex: 1,
            child: LogoWidget()
        ),

        Expanded(
          flex: 7,
          child: RegisterFormWidget(
            phoneController:  phoneController,
            emailController:  emailController,
            nameController:   nameController,
            passController:   passController,
          ),
        ),

      ],
    );
  }
}
