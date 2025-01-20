import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.05,
            width: MediaQuery.sizeOf(context).width * 0.5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    MediaQuery.sizeOf(context).height * 0.03),
                color: ColorManager.white,
                border:
                    Border.all(color: ColorManager.primaryBlue, width: 1.5)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).height * 0.02,
                  vertical: MediaQuery.sizeOf(context).height * 0.01,
              ),
              child: TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: ColorManager.primaryBlue,
                  ),
                  border: InputBorder.none,
                  hintText: 'بحث',
                  hintStyle: TextStyles.textStyle18Medium
                      .copyWith(color: ColorManager.primaryBlue),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
