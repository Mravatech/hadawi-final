import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/verifiy_otp_code/widgets/resend_code_button.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerfiyCodeViewBody extends StatefulWidget {
  const VerfiyCodeViewBody({super.key,
    required this.verificationId,
    required this.gender,
    required this.city,
    required this.name,
    required this.phone,
    required this.brithDate,
    required this.email,
    required this.isLogin,
  });
  final String verificationId;
  final String gender;
  final String city;
  final String name;
  final String phone;
  final String brithDate;
  final String email;
  final bool isLogin;


  @override
  State<VerfiyCodeViewBody> createState() => _VerfiyCodeViewBodyState();
}

class _VerfiyCodeViewBodyState extends State<VerfiyCodeViewBody> {
  TextEditingController verifyOtpPinPutController = TextEditingController();
  GlobalKey<FormState> otpKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().resendOtpTimer();
  }


  @override
  void dispose() {
    context.read<AuthCubit>().secondTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).height * .035),
          child: Form(
            key: otpKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: MediaQuery.sizeOf(context).height * 0.18,),

                /// text
                Text('ادخل كود التحقق', style: TextStyles.textStyle18Bold,),

                SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),

                /// text
                Text('لقد ارسلنا لك رساله نصبه الي رقم هاتفك تحتوي علي رمز التحقق المكون من سته ارقام',
                  style:  TextStyles.textStyle18Bold,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: MediaQuery.sizeOf(context).height * .05,),

                Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: PinCodeTextField(
                    length: 6,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please enter your code';
                      }
                      return null;
                    },
                    obscureText: false,
                    cursorColor: ColorManager.primaryBlue,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveFillColor: ColorManager.gray,
                      inactiveColor: ColorManager.gray,
                      activeColor:ColorManager.primaryBlue,
                      selectedColor: ColorManager.gray,
                      selectedFillColor: ColorManager.gray,
                    ),
                    keyboardType: TextInputType.number,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    controller: verifyOtpPinPutController,
                    onCompleted: (v) {},
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                  ),
                ),

                SizedBox(height: MediaQuery.sizeOf(context).height * .01,),

                // resend code button and timer
                ResendCodeButton(
                  email: widget.email,
                  phone: widget.phone,
                  name: widget.name,
                ),

                SizedBox(height: MediaQuery.sizeOf(context).height * .05,),

                BlocConsumer<AuthCubit,AuthStates>(
                  listener: (context, state) {
                    if(state is VerifiyOtpCodeSuccessState){
                      customPushAndRemoveUntil(context, HomeLayout());
                    }
                    if(state is VerifiyOtpCodeErrorState){
                      customToast(title: state.message , color: ColorManager.error);
                    }
                  },
                  builder: (context, state) {
                    var cubit = context.read<AuthCubit>();
                    return state is VerifiyOtpCodeLoadingState ?
                    const CircularProgressIndicator()
                        : DefaultButton(
                        buttonText: 'تاكيد',
                        onPressed: (){
                          cubit.verifiyOtpCode(
                              email: widget.email,
                              phone: widget.phone,
                              name: widget.name,
                              isLogin: widget.isLogin,
                              brithDate: widget.brithDate,
                              gender: widget.gender,
                              city: widget.city,
                              verificationId: widget.verificationId,
                              verifyOtpPinPut: verifyOtpPinPutController.text
                          );
                        },
                        buttonColor: ColorManager.primaryBlue
                    );
                  },
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
