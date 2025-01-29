import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String)? onChanged;
  const SearchBarWidget({super.key, required this.searchController,required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.05,
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
          controller: searchController,
          onChanged: onChanged,
          style: TextStyles.textStyle18Medium
              .copyWith(color: ColorManager.primaryBlue),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: ColorManager.primaryBlue,
            ),
            border: InputBorder.none,
            hintText: AppLocalizations.of(context)!.translate('search').toString(),
            hintStyle: TextStyles.textStyle18Medium
                .copyWith(color: ColorManager.primaryBlue),
          ),
        ),
      ),
    );
  }
}
