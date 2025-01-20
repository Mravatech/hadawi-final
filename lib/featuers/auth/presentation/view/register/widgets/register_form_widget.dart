import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/already_have_an_account.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/country_code_widget.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/select_gender_widget.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/verifiy_otp_code/verifiy_otp_code_screen.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/toast.dart';

class RegisterFormWidget extends StatelessWidget {
   RegisterFormWidget({super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    });

  final TextEditingController nameController ;
  final TextEditingController phoneController ;
  final TextEditingController emailController ;

  GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
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

              Text('المعلومات الشخصية',style: TextStyles.textStyle24Bold.copyWith(
                  fontSize: MediaQuery.sizeOf(context).height*0.025
              )),

              SizedBox( height:  MediaQuery.sizeOf(context).height*0.035,),

              // name
              DefaultTextField(
                  controller: nameController,
                  hintText: 'ادخل اسمك',
                  validator: (value) {
                    if(value.isEmpty){
                      return 'رجاء ادخال اسمك';
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
                  hintText: ' ادخل رقم هاتفك',
                  validator: (value) {
                    if(value.isEmpty){
                      return 'رجاء ادخال رقم هاتفك';
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
                  hintText: 'ادخل البريد الالكتروني',
                  validator: (value) {
                    if(value.isEmpty){
                      return 'رجاء ادخال البريد الالكتروني';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
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
                      helpText: 'ادخل تاريخ ميلادك',
                      context: context,
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now(),
                    ).then((value) =>cubit.setBrithDate(brithDateValue: value!)),
                    child: DefaultTextField(
                        enable: false,
                        controller: cubit.brithDateController,
                        hintText: cubit.brithDateController.text.isEmpty?
                        'ادخل تاريخ ميلادك':cubit.brithDateController.text,
                        validator: (value) {
                          if(value.isEmpty){
                            return 'رجاء ادخال تاريخ ميلادك';
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
                 print('state $state');
                },
                builder: (context, state) {
                  var cubit = context.read<AuthCubit>();
                  return state is LoginWithPhoneLoadingState?
                  Center(
                    child: CircularProgressIndicator(),
                  ):
                  DefaultButton(
                      buttonText: 'تسجيل',
                      onPressed: (){
                        if(registerKey.currentState!.validate()){
                          cubit.loginWithPhone(
                              phone: phoneController.text,
                              context: context,
                              resendCode: false,
                              email:emailController.text,
                              brithDate: cubit.brithDateController.text,
                              gender: cubit.genderValue,
                              name: nameController.text
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
    );
  }
}
