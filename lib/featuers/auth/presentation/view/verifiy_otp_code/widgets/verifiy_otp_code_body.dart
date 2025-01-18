//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:ui' as ui;
//
// import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
// import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
//
// class VerfiyCodeViewBody extends StatefulWidget {
//   const VerfiyCodeViewBody({super.key, required this.verificationId, required this.phoneNumber, required this.id,required this.isRegister});
//   final String verificationId;
//   final String phoneNumber;
//   final int id;
//   final bool isRegister;
//
//   @override
//   State<VerfiyCodeViewBody> createState() => _VerfiyCodeViewBodyState();
// }
//
// class _VerfiyCodeViewBodyState extends State<VerfiyCodeViewBody> {
//   TextEditingController controller = TextEditingController();
//   GlobalKey<FormState> otpKey = GlobalKey<FormState>();
//
//
//   @override
//   void initState() {
//     super.initState();
//     // AuthCubit.get(context).verifyOtpPinPutController = TextEditingController();
//     // context.read<AuthCubit>().resendOtpTimer();
//
//   }
//
//
//   @override
//   void dispose() {
//     // AuthCubit.get(context).verifyOtpPinPutController.dispose();
//     // context.read<AuthCubit>().secondTimer!.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthCubit,AuthStates>(
//       listener: (context, state) {
//
//       },
//       builder: (context, state) {
//         var cubit = context.read<AuthCubit>();
//         return  ModalProgressHUD(
//           inAsyncCall: cubit.isVerifyLoading==true,
//           progressIndicator: const CupertinoActivityIndicator(),
//           child: Container(
//             height: MediaQuery.sizeOf(context).height,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF00A5CF), Color(0xFF055062)],
//                 stops: [0.0, 1.0],
//                 begin: AlignmentDirectional(0.57, -1.0),
//                 end: AlignmentDirectional(-0.57, 1.0),
//               ),
//             ),
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).height * .035),
//                 child: Form(
//                   key: otpKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//
//                       SizedBox(height: MediaQuery.sizeOf(context).height * 0.18,),
//
//                       /// text
//                       Text(FFLocalizations.of(context).getText('enterOtpCode'),
//                         style:  FlutterFlowTheme.of(context).bodyLarge.override(
//                           fontFamily: 'ITC Avant Garde Gothic Pro',
//                           color: Colors.white,
//                           fontSize: UserDataFromStorage.fontSize =='Small'?Constants.titleSmall+1:
//                           UserDataFromStorage.fontSize=='Medium'?Constants.titleMedium+1:Constants.titleLarge+1,
//                           letterSpacing: 0.0,
//                           fontWeight: FontWeight.normal,
//                           useGoogleFonts: GoogleFonts.asMap().containsKey('ITC Avant Garde Gothic Pro'),
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//
//                       SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
//
//                       /// text
//                       Text(FFLocalizations.of(context).getText('otpMessage'),
//                         style:  FlutterFlowTheme.of(context).bodyLarge.override(
//                           fontFamily: 'ITC Avant Garde Gothic Pro',
//                           color: FlutterFlowTheme.of(context).primaryBackground,
//                           fontSize:UserDataFromStorage.fontSize =='Small'?Constants.bodySmall+1:
//                           UserDataFromStorage.fontSize=='Medium'?Constants.bodyMedium+1:Constants.bodyLarge+1,
//                           letterSpacing: 0.0,
//                           fontWeight: FontWeight.normal,
//                           useGoogleFonts: GoogleFonts.asMap().containsKey('ITC Avant Garde Gothic Pro'),
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//
//                       SizedBox(height: MediaQuery.sizeOf(context).height * .05,),
//
//                       Directionality(
//                         textDirection: ui.TextDirection.ltr,
//                         child: PinCodeTextField(
//                           length: 6,
//                           validator: (value){
//                             if(value!.isEmpty){
//                               return FFLocalizations.of(context).getText('pinCodeEmpty');
//                             }
//                           },
//                           obscureText: false,
//                           cursorColor: FlutterFlowTheme.of(context).mainColor,
//                           animationType: AnimationType.fade,
//                           pinTheme: PinTheme(
//                             shape: PinCodeFieldShape.box,
//                             borderRadius: BorderRadius.circular(5),
//                             fieldHeight: 50,
//                             fieldWidth: 40,
//                             activeFillColor: Colors.white,
//                             inactiveFillColor: Colors.grey[100],
//                             inactiveColor: Colors.grey[100],
//                             activeColor:FlutterFlowTheme.of(context).mainColor,
//                             selectedColor: Colors.grey[100],
//                             selectedFillColor: Colors.grey[100],
//                           ),
//                           keyboardType: TextInputType.number,
//                           animationDuration: const Duration(milliseconds: 300),
//                           enableActiveFill: true,
//                           controller: cubit.verifyOtpPinPutController,
//                           onCompleted: (v) {},
//                           onChanged: (value) {},
//                           beforeTextPaste: (text) {
//                             return true;
//                           },
//                           appContext: context,
//                         ),
//                       ),
//
//                       SizedBox(height: MediaQuery.sizeOf(context).height * .01,),
//
//                       // resend code button and timer
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Visibility(
//                             visible: true,
//                             child: Text(
//                               '${AuthCubit.get(context).second}',
//                               style: TextStyle(
//                                 fontSize: MediaQuery.sizeOf(context).height * .02,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//
//                           SizedBox(width: MediaQuery.sizeOf(context).height * 0.002,),
//
//                           TextButton(
//                             onPressed: () {
//                               if(AuthCubit.get(context).resendButton==true){
//                                 context.read<AuthCubit>().secondTimer!.cancel();
//                                 AuthCubit.get(context).resendVerifyFunction(
//                                     context: context,
//                                     code: cubit.dataCountryCode!.dialCode!,
//                                     phoneNumber: widget.phoneNumber
//                                 ).then((value) {
//                                   AuthCubit.get(context).resendOtpTimer();
//                                 });
//                               }
//                             },
//                             child: Text(
//                               FFLocalizations.of(context).getText(
//                                   'resendCode'
//                               ),
//                               style: TextStyle(
//                                 decoration: AuthCubit.get(context).resendButton==false?TextDecoration.none:TextDecoration.underline,
//                                 fontSize: UserDataFromStorage.fontSize =='Small'?Constants.bodySmall+1:
//                                 UserDataFromStorage.fontSize=='Medium'?Constants.bodyMedium+1:Constants.bodyLarge+1,
//                                 fontWeight: FontWeight.w500,
//                                 color: AuthCubit.get(context).resendButton==false?Colors.grey:Colors.white,
//                               ),
//
//                             ),
//                           ),
//                         ],
//                       ),
//
//
//                       SizedBox(height: MediaQuery.sizeOf(context).height * .05,),
//
//                       LoginButton(
//                         phoneNumber: widget.phoneNumber,
//                         id:widget.id ,
//                         isRegister: widget.isRegister,
//                         otpKey: otpKey,
//                         verificationId:widget.verificationId ,
//                       ),
//
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
