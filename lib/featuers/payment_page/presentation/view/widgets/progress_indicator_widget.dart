import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double value;
  const ProgressIndicatorWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.height * 0.04,
      child: Stack(
        alignment: Alignment.center,
        children: [
          LinearProgressIndicator(
            value: value,
            backgroundColor: ColorManager.gray,
            color: ColorManager.primaryBlue,
            minHeight: SizeConfig.height * 0.04,
            borderRadius:
            BorderRadius.circular(SizeConfig.height * 0.03),
          ),
          Text(
            "${value*100}%",
            style: TextStyles.textStyle18Medium.copyWith(
              color: ColorManager.black,
            ),
          ),
        ],
      ),
    );
  }
}
