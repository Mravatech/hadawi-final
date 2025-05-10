import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/widgets/login_form_widget.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/login_widget.dart';
import 'package:hadawi_app/widgets/toast.dart';


class ForgetPasswordViewBody extends StatefulWidget {
  const ForgetPasswordViewBody({super.key});

  @override
  State<ForgetPasswordViewBody> createState() => _ForgetPasswordViewBodyState();
}

class _ForgetPasswordViewBodyState extends State<ForgetPasswordViewBody> {

  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> forgetPasswordKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: LogoWidget()
        ),

        Expanded(
          flex: 4,
          child: GestureDetector(
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
                  key: forgetPasswordKey,
                  child: Column(
                    children: [
                      Text(
                          AppLocalizations.of(context)!.translate('forgetPassword').toString(),
                          style: TextStyles.textStyle24Bold),

                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.035,
                      ),

                      // email
                      DefaultTextField(
                          controller: emailController,
                          hintText: AppLocalizations.of(context)!
                              .translate('emailHint')
                              .toString(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .translate('emailMessage')
                                  .toString();
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          fillColor: ColorManager.gray),


                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.045,
                      ),

                      // sign in
                      BlocConsumer<AuthCubit, AuthStates>(listener: (context, state) {
                        if (state is ResetPasswordSuccessState) {
                          customToast(
                            title: AppLocalizations.of(context)!
                                .translate('sentResetLink')
                                .toString(),
                            color: ColorManager.success
                          );
                          context.replace(AppRouter.login);
                        }
                        if (state is ResetPasswordErrorState) {

                        }
                      }, builder: (context, state) {
                        var cubit = context.read<AuthCubit>();
                        return
                          state is ResetPasswordLoadingState ? const CircularProgressIndicator(): DefaultButton(
                              buttonText: AppLocalizations.of(context)!
                                  .translate('resetPassword')
                                  .toString(),
                              onPressed: () async {
                                if (forgetPasswordKey.currentState!.validate()) {
                                  await cubit.resetPassword(email: emailController.text.trim());
                                }
                              },
                              buttonColor: ColorManager.primaryBlue);
                      }),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.02,
                      ),
                      DefaultButton(
                          buttonText: AppLocalizations.of(context)!
                              .translate('cancel')
                              .toString(),
                          onPressed: () {
                           Navigator.pop(context);
                          },
                          buttonColor: ColorManager.gray)

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
