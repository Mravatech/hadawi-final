import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class ProfileRowWidget extends StatelessWidget {
  const ProfileRowWidget({super.key, required this.image, required this.title});
  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width*0.9,
      decoration: BoxDecoration(
          color: ColorManager.primaryBlue,
          borderRadius: BorderRadius.circular(50)
      ),
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width*0.05,
          vertical: MediaQuery.sizeOf(context).height*0.02
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image !=''?
          Image(
            image: AssetImage(image),
            color: ColorManager.white,
            height: MediaQuery.sizeOf(context).height*0.025,
            width: MediaQuery.sizeOf(context).height*0.025,
          ):Container(),
          image !=''?
          SizedBox(width: MediaQuery.sizeOf(context).width*0.05,):
          Container(),
          Text(title,style: TextStyles.textStyle18Bold.copyWith(
              color: ColorManager.white,
              fontSize:MediaQuery.sizeOf(context).height*0.022
          ),)
        ],
      ),
    );
  }
}