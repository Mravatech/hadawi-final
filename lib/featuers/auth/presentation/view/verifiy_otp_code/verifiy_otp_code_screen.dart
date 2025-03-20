import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/register_screen.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/verifiy_otp_code/widgets/verifiy_otp_code_body.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';

class VerifyPhoneScreen extends StatelessWidget {
  final String verificationId;
  final String gender;
  final String name;
  final String phone;
  final String city;
  final String brithDate;
  final String email;
  final bool isLogin;

  const VerifyPhoneScreen({super.key,
    required this.verificationId,
    required this.gender,
    required this.name,
    required this.phone,
    required this.city,
    required this.brithDate,
    required this.email,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          customPushAndRemoveUntil(context, RegisterScreen());
          },
          icon: Icon(Icons.arrow_back_ios
        ),),
        backgroundColor: ColorManager.gray,
        centerTitle: true,
        title: Text('تاكيد رقم الهاتف',style: TextStyles.textStyle18Bold,),
      ),
      body: WillPopScope(
        onWillPop: (){
          customPushAndRemoveUntil(context, RegisterScreen());
          return Future.value(true);
        },
        child: VerfiyCodeViewBody(
          verificationId: verificationId,
          gender: gender,
          name: name,
          phone: phone,
          city: city,
          brithDate: brithDate,
          email: email,
          isLogin: isLogin,
        ),
      ),
    );
  }
}