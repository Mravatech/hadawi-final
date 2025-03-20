import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class ResendCodeButton extends StatelessWidget {
  const ResendCodeButton({super.key,required this.name,required this.email,required this.phone});
  final String name;
  final String email;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit,AuthStates>(
      builder: (context,state){
        var cubit=context.read<AuthCubit>();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: true,
              child: Text(
                '${cubit.second}',
                style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).height * .02,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(width: MediaQuery.sizeOf(context).height * 0.001,),

            TextButton(
              onPressed: () {
                if(cubit.resendButton==true){
                  context.read<AuthCubit>().secondTimer!.cancel();
                  cubit.loginWithPhone(
                     brithDate: cubit.brithDateController.text,
                     email: '',
                     isLogin: false,
                     gender: cubit.genderValue,
                     name: '',
                     phone: '',
                     city: '',
                     resendCode:true,
                     context: context
                  ).then((value) {
                    cubit.resendOtpTimer();
                  });
                }
              },
              child: Text('اعاده ارسال الكود',style: TextStyles.textStyle18Bold,),
            ),
          ],
        );
      },
    );
  }
}
