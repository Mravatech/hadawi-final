import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/widgets/default_button_with_image.dart';
import 'package:hadawi_app/widgets/toast.dart';

class LoginWithSocialButton extends StatelessWidget {
  const LoginWithSocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthStates>(
      listener: (context, state) {
        if(state is SignInWithSocialMediaErrorState){
          customToast(title: state.message, color: ColorManager.primaryBlue);
        }
        if(state is SignInWithSocialMediaSuccessState){
          customPushAndRemoveUntil(context, HomeLayout());
        }
      },
      builder: (context, state) {
        var cubit = context.read<AuthCubit>();
        return state is SignInWithSocialMediaLoadingState?
        const CircularProgressIndicator():
        Row(
          children: [
            Expanded(
              child: DefaultButtonWithImage(
                image:AssetsManager.googleIcon ,
                buttonText: 'ادخل باستخدام',
                onTap: (){
                  cubit.signInWithGoogle(brithDate: '', gender:'');
                },
              ),
            ),
            SizedBox( width:  MediaQuery.sizeOf(context).height*0.02,),
            Expanded(
              child: DefaultButtonWithImage(
                image:AssetsManager.appleIcon ,
                buttonText: 'ادخل باستخدام',
                onTap: (){},
              ),
            ),
          ],
        );
      },
    );
  }
}
