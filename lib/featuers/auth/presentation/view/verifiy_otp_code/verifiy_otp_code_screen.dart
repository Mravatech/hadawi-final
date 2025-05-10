import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/register_screen.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/verifiy_otp_code/widgets/verifiy_otp_code_body.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';

class VerifyPhoneScreen extends StatelessWidget {
  final String verificationOtp;
  final String gender;
  final String name;
  final String phone;
  final String city;
  final String brithDate;
  final String email;
  final String password;

  const VerifyPhoneScreen({super.key,
   required  this.verificationOtp,
   required  this.gender,
   required  this.name,
   required  this.phone,
   required  this.city,
   required  this.brithDate,
   required  this.email,
   required  this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios
        ),),
        backgroundColor: ColorManager.gray,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.translate('confirm_phone_number').toString(),style: TextStyles.textStyle18Bold,),
      ),
      body: WillPopScope(
        onWillPop: (){
          Navigator.pop(context);
          return Future.value(true);
        },
        child: VerfiyCodeViewBody(
          verificationId: verificationOtp,
          gender: gender,
          name: name,
          phone: phone,
          city: city,
          brithDate: brithDate,
          email: email,
          password: password,
        ),
      ),
    );
  }
}