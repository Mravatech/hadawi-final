import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/widgets/login_form_widget.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/localiztion/localization_cubit.dart';
import 'package:hadawi_app/utiles/localiztion/localization_states.dart';
import 'package:hadawi_app/widgets/login_widget.dart';

import '../../../../../../styles/text_styles/text_styles.dart';


class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    passController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),
                BlocBuilder<LocalizationCubit,LocalizationStates>(
                  builder: (context,state){
                    return GestureDetector(
                      onTap: (){
                        CashHelper.getData(key: CashHelper.languageKey).toString()=='en'?
                        context.read<LocalizationCubit>().changeLanguage(code: 'ar'):
                        context.read<LocalizationCubit>().changeLanguage(code: 'en');
                      },
                      child: Container(
                          padding:EdgeInsets.symmetric(
                            horizontal: MediaQuery.sizeOf(context).width*0.04,
                            vertical: MediaQuery.sizeOf(context).width*0.00,
                          ),
                          decoration:BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ) ,
                          child:CashHelper.getData(key: CashHelper.languageKey).toString()=='en'?
                          Text('English',style: TextStyles.textStyle18Bold.copyWith(
                              color: ColorManager.black,
                              fontSize:MediaQuery.sizeOf(context).height*0.018
                          ),):
                          Text('عربي',style: TextStyles.textStyle18Bold.copyWith(
                              color: ColorManager.black,
                              fontSize:MediaQuery.sizeOf(context).height*0.018
                          ))
                      ),
                    );
                  } ,
                ),
                SizedBox(
                    height:  MediaQuery.sizeOf(context).height*0.12,
                    child: LogoWidget()
                ),
              ],
            )
        ),

        Expanded(
          flex: 4,
          child: LoginFormWidget(
            passController: passController,
            emailController: emailController,
          ),
        ),

      ],
    );
  }
}