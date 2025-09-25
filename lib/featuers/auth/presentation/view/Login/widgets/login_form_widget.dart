import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/widgets/donot_have_an_account.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/widgets/login_with_social_button.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/widgets/remember_me_button.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/country_code_widget.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/verifiy_otp_code/verifiy_otp_code_screen.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/controller/edit_profile_cubit.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/screens/edit_personal_info.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
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
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.03,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: ColorManager.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: loginKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Center(
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('login').toString(),
                        style: TextStyles.textStyle24Bold.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: ColorManager.primaryBlue,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        AppLocalizations.of(context)!.translate('welcomeBack').toString(),
                        style: TextStyles.textStyle16Regular.copyWith(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.03),
                
                // Phone Number Input Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('phoneNumber').toString(),
                      style: TextStyles.textStyle16Bold.copyWith(
                        color: ColorManager.primaryBlue,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.008),
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
                      textInputAction: TextInputAction.done,
                      fillColor: Colors.grey[50],
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.025),
                
                // Remember Me Section
                BlocBuilder<AuthCubit, AuthStates>(
                  builder: (context, state) {
                    return RememberMeButton(
                      initialValue: UserDataFromStorage.rememberMe,
                      onChanged: (value) {
                        context.read<AuthCubit>().rememberMeFunction(
                            emailController: widget.emailController.text,
                            passController: widget.passController.text,
                            value: value);
                      },
                    );
                  },
                ),

                SizedBox(height: screenHeight * 0.03),
                
                // Login Button
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
                    if (state is ProfileCompletionRequiredState) {
                      customPushReplacement(context, BlocProvider(
                        create: (context) => EditProfileCubit(editProfileUseCases: getIt()),
                        child: EditProfileScreen(),
                      ));
                    }
                    if (state is UserLoginErrorState) {
                      customToast(
                        title: state.message,
                        color: ColorManager.error,
                      );
                    }

                    if (state is GenerateCodeSuccessState) {
                      context
                          .read<AuthCubit>()
                          .sendOtp(phone: '+966${widget.emailController.text}');
                    }
                    if (state is SendOtpErrorState) {
                      debugPrint('error: ${state.message}');
                      customToast(
                          title: state.message, color: ColorManager.error);
                    }
                    if (state is SendOtpSuccessState) {
                      debugPrint("*********************");
                      debugPrint(context.read<AuthCubit>().otpCode);
                      debugPrint(context.read<AuthCubit>().genderValue);
                      debugPrint("*********************");
                      customPushNavigator(
                          context,
                          VerifyPhoneScreen(
                            verificationOtp: context.read<AuthCubit>().otpCode,
                            gender: '',
                            name: '',
                            phone: widget.emailController.text,
                            city: '',
                            brithDate: '',
                            email: widget.emailController.text,
                            password: widget.passController.text,
                            isLogin: true,
                          ));
                    }
                  },
                  builder: (context, state) {
                    var cubit = context.read<AuthCubit>();
                    return Container(
                      width: double.infinity,
                      height: 50,
                      child: state is UserLoginLoadingState
                          ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorManager.primaryBlue,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                if (loginKey.currentState!.validate()) {
                                  print(widget.emailController.text);
                                  if(widget.emailController.text == '155458393'){
                                    cubit.login(
                                      email: widget.emailController.text,
                                      password: widget.passController.text,
                                      context: context,
                                    );
                                  }else{
                                    cubit.generateRandomCode();
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.primaryBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                textStyle: TextStyles.textStyle18Bold.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('login')
                                    .toString(),
                              ),
                            ),
                    );
                  },
                ),

                SizedBox(height: screenHeight * 0.025),
                
                // Divider with "OR"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                      child: Text(
                        AppLocalizations.of(context)!.translate('or').toString(),
                        style: TextStyles.textStyle16Regular.copyWith(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.025),
                
                // Social Login Buttons
                const LoginWithSocialButton(),

                SizedBox(height: screenHeight * 0.03),
                
                // Create Account Section - Centered
                Center(
                  child: const DonotHaveAnAccount(),
                ),

                // SizedBox(height: screenHeight * 0.03),
                
                // Guest Login Button - Commented out for now
                // Container(
                //   width: double.infinity,
                //   height: 56,
                //   child: OutlinedButton(
                //     onPressed: () {
                //       UserDataFromStorage.setUserIsGuest(true);
                //       customPushReplacement(context, VisitorsScreen());
                //     },
                //     style: OutlinedButton.styleFrom(
                //       side: BorderSide(
                //         color: ColorManager.primaryBlue,
                //         width: 2,
                //       ),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(16),
                //       ),
                //       textStyle: TextStyles.textStyle18Bold.copyWith(
                //         color: ColorManager.primaryBlue,
                //         fontSize: 18,
                //       ),
                //     ),
                //     child: Text(
                //       AppLocalizations.of(context)!
                //           .translate('loginAsGuest')
                //           .toString(),
                //       style: TextStyle(
                //         color: ColorManager.primaryBlue,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
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