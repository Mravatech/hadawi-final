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
        final cubit= context.read<OccasionCubit>();
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: mediaQuery.height * .06,
          width: mediaQuery.width * .75,
          decoration: BoxDecoration(
            color: ColorManager.gray,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Container(
                height: mediaQuery.height * .06,
                width: mediaQuery.width * .375,
                decoration: BoxDecoration(
                  color: cubit.isForMe == false
                      ? ColorManager.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: GestureDetector(
                  onTap: () {
                    cubit.resetData();
                    cubit.switchForWhomOccasion();
                  },
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('forOthers')
                          .toString(),
                      style: TextStyles.textStyle18Bold.copyWith(
                        color: cubit.isForMe==false
                            ? ColorManager.white
                            : ColorManager.black,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: mediaQuery.height * .06,
                width: mediaQuery.width * .375,
                decoration: BoxDecoration(
                  color: cubit.isForMe
                      ? ColorManager.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: GestureDetector(
                  onTap: () {
                    cubit.resetData();
                    cubit.switchForWhomOccasion();
                  },
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('forMe')
                          .toString(),
                      style: TextStyles.textStyle18Bold.copyWith(
                        color: cubit.isForMe
                            ? ColorManager.white
                            : ColorManager.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
