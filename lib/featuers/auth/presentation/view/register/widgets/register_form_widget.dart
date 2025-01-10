import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/already_have_an_account.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/select_gender_widget.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';

class RegisterFormWidget extends StatelessWidget {
   RegisterFormWidget({super.key,
    required this.nameController,
    required this.phoneController,
    required this.passController,
    required this.brithDateController});

  final TextEditingController nameController ;
  final TextEditingController phoneController ;
  final TextEditingController passController ;
  final TextEditingController brithDateController ;

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
                    return 'Please enter your name';
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
                    return 'Please enter your phone number';
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
                    return 'Please enter your password';
                  },
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  fillColor: ColorManager.gray
              ),

              SizedBox( height:  MediaQuery.sizeOf(context).height*0.03,),

              // birth date
              GestureDetector(
                onTap:  ()=>showDatePicker(
                  helpText: 'Select your birth date',
                  context: context,
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                ),
                child: DefaultTextField(
                    enable: false,
                    controller: brithDateController,
                    hintText: 'Enter your birth date',
                    validator: (value) {
                      return 'Please enter your birth date';
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    fillColor: ColorManager.gray
                ),
              ),

              SizedBox( height:  MediaQuery.sizeOf(context).height*0.03,),

              // gender
              SelectGenderWidget(),

              SizedBox( height:  MediaQuery.sizeOf(context).height*0.04,),

              // sign up
              DefaultButton(
                  buttonText: 'Sign up',
                  onPressed: (){
                    if(registerKey.currentState!.validate()){

                    }
                  },
                  buttonColor: ColorManager.primaryBlue
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
