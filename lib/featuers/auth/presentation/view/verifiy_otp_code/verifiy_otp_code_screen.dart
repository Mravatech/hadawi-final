//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hadawi_app/featuers/auth/presentation/view/verifiy_otp_code/widgets/verifiy_otp_code_body.dart';
// import 'package:hadawi_app/styles/colors/color_manager.dart';
// import 'package:hadawi_app/styles/text_styles/text_styles.dart';
//
// class VerifyPhoneScreen extends StatelessWidget {
//   final String verificationId;
//   final String phoneNumber;
//   final int id;
//   final bool isRegister;
//
//   const VerifyPhoneScreen({super.key,
//     required this.verificationId,
//     required this.phoneNumber,
//     required this.id,
//     required this.isRegister
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0.0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         systemOverlayStyle: const SystemUiOverlayStyle(
//             statusBarColor: Colors.transparent,
//             statusBarIconBrightness: Brightness.light
//         ),
//         backgroundColor: ColorManager.primaryBlue,
//         centerTitle: true,
//         title: Text('Verify Phone Number',style: TextStyles.textStyle18Bold,),
//       ),
//       body: VerfiyCodeViewBody(
//         phoneNumber: phoneNumber,
//         verificationId:verificationId ,
//         id: id,
//         isRegister: isRegister,
//       ),
//     );
//   }
// }