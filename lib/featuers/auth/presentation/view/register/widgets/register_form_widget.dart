import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/already_have_an_account.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/select_gender_widget.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/toast.dart';

class RegisterFormWidget extends StatelessWidget {
   RegisterFormWidget({super.key,
    required this.nameController,
    required this.phoneController,
    required this.passController,
    });

  final TextEditingController nameController ;
  final TextEditingController phoneController ;
  final TextEditingController passController ;

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

              Text('Personal information',style: TextStyles.textStyle24Bold.copyWith(
                  fontSize: MediaQuery.sizeOf(context).height*0.025
              )),

              SizedBox( height:  MediaQuery.sizeOf(context).height*0.035,),

              // name
              DefaultTextField(
                  controller: nameController,
                  hintText: 'Enter your name',
                  validator: (value) {
                    if(value.isEmpty){
                      return 'Please enter your name';
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
                  controller: phoneController,
                  hintText: 'Enter your phone number',
                  validator: (value) {
                    if(value.isEmpty){
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  fillColor: ColorManager.gray
              ),

              SizedBox( height:  MediaQuery.sizeOf(context).height*0.03,),

              // password
              DefaultTextField(
                  viewPassword: true,
                  withSuffix: true,
                  controller: passController,
                  hintText: 'Enter your password',
                  validator: (value) {
                    if(value.isEmpty){
                      return 'Please enter your password';
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
                      helpText: 'Select your birth date',
                      context: context,
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now(),
                    ).then((value) =>cubit.setBrithDate(brithDateValue: value!)),
                    child: DefaultTextField(
                        enable: false,
                        controller: cubit.brithDateController,
                        hintText: cubit.brithDateController.text.isEmpty?
                        'Select your birth date':cubit.brithDateController.text,
                        validator: (value) {
                          if(value.isEmpty){
                            return 'Please enter your birth date';
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
                  if(state is UserRegisterSuccessState){
                    Navigator.pushNamed(context, '/login_screen');
                  }
                  if(state is UserRegisterErrorState){
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
                      buttonText: 'Sign up',
                      onPressed: (){
                        if(registerKey.currentState!.validate()){
                          cubit.register(
                              email: phoneController.text,
                              password: passController.text,
                              brithDate: cubit.brithDateController.text,
                              gender: cubit.genderValue,
                              name: nameController.text,
                              phone: phoneController.text
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
