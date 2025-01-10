import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';


class DefaultButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  double? width;
  final Color buttonColor;

   DefaultButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.width = double.infinity,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.sizeOf(context).height*0.05,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height*0.01),
        color: buttonColor,
      ),

      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyles.textStyle18Bold.copyWith(
            color: ColorManager.white
          ),
        ),
      ),
    );
  }
}

