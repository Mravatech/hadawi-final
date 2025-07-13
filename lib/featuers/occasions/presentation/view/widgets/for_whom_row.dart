import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';

import '../../../../../utiles/localiztion/app_localization.dart';

class ForWhomRow extends StatefulWidget {
  const ForWhomRow({super.key});

  @override
  State<ForWhomRow> createState() => _ForWhomRowState();
}

class _ForWhomRowState extends State<ForWhomRow> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    return BlocBuilder<OccasionCubit, OccasionState>(
      builder: (context, state) {
        final cubit = context.read<OccasionCubit>();
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: mediaQuery.width * 0.05,
            vertical: mediaQuery.height * 0.01,
          ),
          height: mediaQuery.height * 0.06,
          decoration: BoxDecoration(
            color: ColorManager.gray.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColorManager.gray.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildSegment(
                  context: context,
                  isSelected: !cubit.isForMe,
                  onTap: () {
                    cubit.resetData();
                    cubit.switchForWhomOccasion();
                  },
                  label: AppLocalizations.of(context)!.translate('forOthers').toString(),
                ),
              ),
              Expanded(
                child: _buildSegment(
                  context: context,
                  isSelected: cubit.isForMe,
                  onTap: () {
                    cubit.resetData();
                    cubit.switchForWhomOccasion();
                  },
                  label: AppLocalizations.of(context)!.translate('forMe').toString(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSegment({
    required BuildContext context,
    required bool isSelected,
    required VoidCallback onTap,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isSelected
            ? LinearGradient(
                colors: [
                  ColorManager.primaryBlue,
                  ColorManager.primaryBlue.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
            ? [
                BoxShadow(
                  color: ColorManager.primaryBlue.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
        ),
        margin: EdgeInsets.all(4),
        child: Center(
          child: Text(
            label,
            style: TextStyles.textStyle16Bold.copyWith(
              color: isSelected 
                ? ColorManager.white 
                : ColorManager.black.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
