import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';

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

            SizedBox(width: MediaQuery.sizeOf(context).height * 0.01,),

            cubit.resendButton==true?
            TextButton(
              onPressed: () {
                if(cubit.resendButton==true){
                  context.read<AuthCubit>().secondTimer!.cancel();
                  cubit.generateRandomCode();
                  cubit.resendOtpTimer();
                }
              },
              child: Text(AppLocalizations.of(context)!.translate('resend_code').toString(),style: TextStyles.textStyle18Bold,),
            ):Text(AppLocalizations.of(context)!.translate('resend_code').toString(),style: TextStyles.textStyle18Bold.copyWith(
                color: Colors.grey
              )),
          ],
        );
      },
    );
  }
}
