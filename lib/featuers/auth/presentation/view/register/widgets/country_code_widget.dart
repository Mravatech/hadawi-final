import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class CountryCodeWidget extends StatelessWidget {
  const CountryCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).height*0.005
      ),
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).height*0.005,
        vertical: MediaQuery.sizeOf(context).height*0.005,
      ),
      height:  MediaQuery.sizeOf(context).height*0.04,
      width:  MediaQuery.sizeOf(context).height*0.07,
      decoration: BoxDecoration(
        color: ColorManager.gray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment:  MainAxisAlignment.center,
        children: [
          Text('+20',style: TextStyles.textStyle18Medium.copyWith(
              color: ColorManager.black,
              fontSize:  MediaQuery.sizeOf(context).height*0.017
          )),
          SizedBox(width:MediaQuery.sizeOf(context).height*0.01,),
          Container(
            height:  MediaQuery.sizeOf(context).height*0.04,
            width:  MediaQuery.sizeOf(context).height*0.002,
            color: ColorManager.black,
          )
        ],
      ),
    );
  }
}
