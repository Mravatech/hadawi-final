import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class DefaultButtonWithImage extends StatelessWidget {
  const DefaultButtonWithImage({super.key,required this.buttonText,required this.image,this.onTap});
  final String buttonText;
  final String image;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        height: MediaQuery.sizeOf(context).height*0.05,
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height*0.01,
            horizontal: MediaQuery.sizeOf(context).height*0.015
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height*0.01),
          color:  ColorManager.primaryBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(buttonText,style: TextStyles.textStyle18Bold.copyWith(
                color: ColorManager.white,
                fontSize: MediaQuery.sizeOf(context).height*0.016
            ),),
            SizedBox( width:MediaQuery.sizeOf(context).height*0.01,),
            Image(
              height: MediaQuery.sizeOf(context).height*0.03,
              color: ColorManager.white,
              image: AssetImage(image),
            )

          ],
        ),
      ),
    );
  }
}
