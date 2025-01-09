import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text('Login',
            style: TextStyles.textStyle24Bold,
          ),
        ],
      ),
    );
  }
}
