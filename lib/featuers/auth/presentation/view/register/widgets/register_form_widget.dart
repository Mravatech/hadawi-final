import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/already_have_an_account.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/country_code_widget.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/select_gender_widget.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/verifiy_otp_code/verifiy_otp_code_screen.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/toast.dart';

class RegisterFormWidget extends StatelessWidget {
   RegisterFormWidget({super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.passController,
    });

  final TextEditingController nameController ;
  final TextEditingController phoneController ;
  final TextEditingController emailController ;
  final TextEditingController passController ;

  GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Form(
        key: registerKey,
        child: Container(
          padding: EdgeInsets.all(MediaQuery.sizeOf(context).height*0.03),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorManager.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox( height:  MediaQuery.sizeOf(context).height*0.01,),

                Text(AppLocalizations.of(context)!.translate('personalInfo').toString()
                    ,style: TextStyles.textStyle24Bold.copyWith(
                    fontSize: MediaQuery.sizeOf(context).height*0.025
                )),

                SizedBox( height:  MediaQuery.sizeOf(context).height*0.035,),

                // name
                DefaultTextField(
                    controller: nameController,
                    hintText: AppLocalizations.of(context)!.translate('fullNameHint').toString(),
                    validator: (value) {
                      if(value.isEmpty){
                        return AppLocalizations.of(context)!.translate('fullNameMessage').toString();
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorManager.gray
                ),

                SizedBox( height:  MediaQuery.sizeOf(context).height*0.03,),

                // phone number
                DefaultTextField(
                    prefix:CountryCodeWidget(),
                    controller: phoneController,
                    hintText: AppLocalizations.of(context)!.translate('loginPhoneHint').toString(),
                    validator: (value) {
                      if(value.isEmpty){
                        return AppLocalizations.of(context)!.translate('loginMessage').toString();
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorManager.gray
                ),

                SizedBox( height:  MediaQuery.sizeOf(context).height*0.03,),

                // email
                DefaultTextField(
                    controller: emailController,
                    hintText: AppLocalizations.of(context)!.translate('emailHint').toString(),
                    validator: (value) {
                      if(value.isEmpty){
                        return AppLocalizations.of(context)!.translate('emailMessage').toString();
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    fillColor: ColorManager.gray
                ),


                SizedBox( height:  MediaQuery.sizeOf(context).height*0.035,),

                DefaultTextField(
                    isPassword: true,
                    withSuffix: true,
                    controller: passController,
                    hintText: AppLocalizations.of(context)!.translate('loginPasswordHint').toString(),
                    validator: (value) {
                      if(value.isEmpty){
                        return AppLocalizations.of(context)!.translate('validPassword').toString();
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    fillColor: ColorManager.gray
                ),

                SizedBox( height:  MediaQuery.sizeOf(context).height*0.03,),

                // birth date
                BlocBuilder<AuthCubit,AuthStates>(
                  builder: (context,state) {
                    var cubit= context.read<AuthCubit>();
                    return GestureDetector(
                      onTap:  ()=>showDatePicker(
                        helpText: AppLocalizations.of(context)!.translate('brithHint').toString(),
                        context: context,
                        firstDate: DateTime(1920),
                        lastDate: DateTime.now(),
                      ).then((value) =>cubit.setBrithDate(brithDateValue: value!)),
                      child: DefaultTextField(
                          enable: false,
                          controller: cubit.brithDateController,
                          hintText: cubit.brithDateController.text.isEmpty?
                          AppLocalizations.of(context)!.translate('brithHint').toString() :
                          cubit.brithDateController.text,
                          validator: (value) {
                            if(value.isEmpty){
                              return AppLocalizations.of(context)!.translate('brithMessage').toString();
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          fillColor: ColorManager.gray
                      ),
                    );
                  },
                ),

                SizedBox( height:  MediaQuery.sizeOf(context).height*0.03,),

                // gender
                SelectGenderWidget(),

                SizedBox( height:  MediaQuery.sizeOf(context).height*0.04,),

                // sign up
                BlocConsumer<AuthCubit,AuthStates>(
                  listener: (context, state) {
                     if( state is UserRegisterSuccessState){
                        customPushAndRemoveUntil(context, HomeLayout());
                     }
                     if( state is UserRegisterErrorState){
                       customToast(title: state.message, color: ColorManager.error);
                     }
                  },
                  builder: (context, state) {
                    var cubit = context.read<AuthCubit>();
                    return state is UserRegisterLoadingState?
                    Center(
                      child: CircularProgressIndicator(),
                    ):
                    DefaultButton(
                        buttonText: AppLocalizations.of(context)!.translate('signUp').toString(),
                        onPressed: (){
                          if(registerKey.currentState!.validate()){
                            cubit.register(
                                email: emailController.text,
                                password: passController.text,
                                phone: phoneController.text,
                                name: nameController.text,
                                brithDate: cubit.brithDateController.text,
                                gender: cubit.genderValue
                            );
                          }
                        },
                        buttonColor: ColorManager.primaryBlue
                    );
                  }
                ),

                SizedBox( height:  MediaQuery.sizeOf(context).height*0.03,),

                // already have an account
                AlreadyHaveAnAccount(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
