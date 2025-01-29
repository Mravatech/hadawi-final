import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/localiztion/localization_cubit.dart';
import 'package:hadawi_app/utiles/localiztion/localization_states.dart';

class RowDataWidget extends StatelessWidget {
  const RowDataWidget({super.key, required this.image, required this.title,required this.lang});
  final String image;
  final String title;
  final bool lang;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width*0.05,
          vertical: MediaQuery.sizeOf(context).height*0.01
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          image !=''?
          Image(
            image: AssetImage(image),
            color: ColorManager.white,
            height: MediaQuery.sizeOf(context).height*0.03,
            width: MediaQuery.sizeOf(context).height*0.03,
          ):Container(),
          image !=''?
          SizedBox(width: MediaQuery.sizeOf(context).width*0.03,):
          Container(),
          Expanded(
            child: Text(title,style: TextStyles.textStyle18Bold.copyWith(
              color: ColorManager.white,
              fontSize:MediaQuery.sizeOf(context).height*0.022
            ),),
          ),
          lang==true?
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
                      vertical: MediaQuery.sizeOf(context).width*0.01,
                    ),
                    decoration:BoxDecoration(
                      color: ColorManager.black,
                      borderRadius: BorderRadius.circular(10),
                    ) ,
                    child:CashHelper.getData(key: CashHelper.languageKey).toString()=='en'?
                    Text('English',style: TextStyles.textStyle18Bold.copyWith(
                        color: ColorManager.white,
                        fontSize:MediaQuery.sizeOf(context).height*0.018
                    ),):
                    Text('عربي',style: TextStyles.textStyle18Bold.copyWith(
                        color: ColorManager.white,
                        fontSize:MediaQuery.sizeOf(context).height*0.018
                    ))
                ),
              );
            } ,
          ):Container(),
        ],
      ),
    );
  }
}
