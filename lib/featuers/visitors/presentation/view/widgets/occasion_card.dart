import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class OccasionCard extends StatelessWidget {
  const OccasionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: ColorManager.gray.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.06,
            decoration: BoxDecoration(
              color: ColorManager.primaryBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                'occasion name',
                style: TextStyles.textStyle18Regular
                    .copyWith(color: ColorManager.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
