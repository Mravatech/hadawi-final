import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/widgets/donot_have_an_account.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/widgets/forget_password_button.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/widgets/login_with_social_button.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/widgets/remember_me_button.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/country_code_widget.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/visitors_screen.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/toast.dart';

class LoginFormWidget extends StatefulWidget {
  final TextEditingController emailController ;
  final TextEditingController passController ;

  const LoginFormWidget({
    super.key,
    required this.emailController,
    required this.passController,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    saveData(
        rememberMe: context.read<AuthCubit>().rememberMe,
        emailController: widget.emailController,
        passController: widget.passController
    );
  }
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.03),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorManager.white,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: loginKey,
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.translate('login').toString(),
                  style: TextStyles.textStyle24Bold,
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.035),
                // Email field

                DefaultTextField(
                    prefix: CountryCodeWidget(
                      color: ColorManager.white,
                    ),
                    controller: widget.emailController,
                    hintText: AppLocalizations.of(context)!
                        .translate('loginPhoneHint')
                        .toString(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .translate('loginPhoneHint')
                            .toString();
                      }
                      if (value.length < 9 || value.length > 9) {
                        return AppLocalizations.of(context)!
                            .translate('validatePhone')
                            .toString();
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorManager.white
                ),


                SizedBox(height: MediaQuery.sizeOf(context).height * 0.025),
                // // Remember Me and Forget Password
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     BlocBuilder<AuthCubit, AuthStates>(
                //       builder: (context, state) {
                //         return RememberMeButton(
                //           initialValue: UserDataFromStorage.rememberMe,
                //           onChanged: (value) {
                //             context.read<AuthCubit>().rememberMeFunction(
                //                 emailController: widget.emailController.text,
                //                 passController: widget.passController.text,
                //                 value: value);
                //           },
                //         );
                //       },
                //     ),
                //     // const ForgetPasswordButton(),
                //   ],
                // ),
                // SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                // Login Button
                // const LoginWithSocialButton(),
                // SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),

                BlocConsumer<AuthCubit, AuthStates>(
                  listener: (context, state) {
                    if (state is UserLoginSuccessState) {
                      saveData(
                          rememberMe: UserDataFromStorage.rememberMe,
                          emailController: widget.emailController,
                          passController: widget.passController
                      );
                      context.read<AuthCubit>().rememberMeFunction(
                          emailController: widget.emailController.text,
                          passController: widget.passController.text,
                          value: UserDataFromStorage.rememberMe);
                      customPushReplacement(context, HomeLayout());
                    }
                    if (state is UserLoginErrorState) {
                      customToast(
                        title: AppLocalizations.of(context)!.translate('phoneError')!.toString(),
                        color: ColorManager.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    var cubit = context.read<AuthCubit>();
                    return state is UserLoginLoadingState
                        ? const CircularProgressIndicator()
                        : DefaultButton(
                      buttonText: AppLocalizations.of(context)!
                          .translate('login')
                          .toString(),
                      onPressed: () {
                        if (loginKey.currentState!.validate()) {
                          cubit.login(
                            email: widget.emailController.text,
                            password: widget.passController.text,
                            context: context,
                          );
                        }
                      },
                      buttonColor: ColorManager.primaryBlue,
                    );
                  },
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.035),
                const DonotHaveAnAccount(),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.035),
                DefaultButton(
                  buttonText: AppLocalizations.of(context)!
                      .translate('loginAsGuest')
                      .toString(),
                  onPressed: () {
                    UserDataFromStorage.setUserIsGuest(true);
                    customPushReplacement(context, VisitorsScreen());
                  },
                  buttonColor: ColorManager.primaryBlue,
                ),
                // SizedBox(height: MediaQuery.sizeOf(context).height * 0.025),
                // GestureDetector(
                //   onTap: () {
                //     context.read<AuthCubit>().launchWhatsApp(
                //         phoneNumber: "+966564940300",
                //         message: AppLocalizations.of(context)!.translate('whatsapp').toString());
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         AppLocalizations.of(context)!.translate('support').toString(),
                //         style: TextStyles.textStyle18Bold.copyWith(
                //             fontSize: 11
                //         ),
                //       ),
                //       SizedBox(width: MediaQuery.sizeOf(context).width * 0.015),
                //       Image(
                //         image: const AssetImage("assets/images/whatsapp.png"),
                //         width: MediaQuery.sizeOf(context).width * 0.08,
                //         height: MediaQuery.sizeOf(context).height * 0.05,
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
void saveData({
  required bool rememberMe,
  required TextEditingController emailController,
  required TextEditingController passController,
}){

  if(UserDataFromStorage.rememberMe!=false){
    rememberMe = UserDataFromStorage.rememberMe;
    emailController.text = UserDataFromStorage.saveEmailFromStorage;
    passController.text = UserDataFromStorage.passwordFromStorage;
  }else{
    rememberMe = false;
    emailController.text = "";
    passController.text = "";
  }

}