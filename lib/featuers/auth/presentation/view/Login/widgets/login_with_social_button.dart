import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/controller/edit_profile_cubit.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/screens/edit_personal_info.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:hadawi_app/widgets/default_button_with_image.dart';

class LoginWithSocialButton extends StatelessWidget {
  const LoginWithSocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthStates>(
      listener: (context, state) {
        if(state is SignInWithSocialMediaErrorState){
          // customToast(title: state.message, color: ColorManager.primaryBlue);
        }
        if(state is SignInWithSocialMediaSuccessState){
          customPushReplacement(context, HomeLayout());
        }
        if(state is ProfileCompletionRequiredState){
          customPushReplacement(context, BlocProvider(
            create: (context) => EditProfileCubit(editProfileUseCases: getIt()),
            child: EditProfileScreen(),
          ));
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
                buttonText: AppLocalizations.of(context)!.translate('continueWith').toString(),
                onTap: (){
                  cubit.signInWithGoogle(brithDate: '', gender:'', city: '',context:  context);
                },
              ),
            ),
            Visibility(
                visible:  Platform.isIOS? true : false,
                child: SizedBox(width: MediaQuery.sizeOf(context).height*0.02,)),
            Visibility(
              visible:  Platform.isAndroid? false : true,
              child: Expanded(
                child: DefaultButtonWithImage(
                  image:AssetsManager.appleIcon ,
                  buttonText: AppLocalizations.of(context)!.translate('continueWith').toString(),
                  onTap: ()async{
                    await cubit.signInWithApple(context: context);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
