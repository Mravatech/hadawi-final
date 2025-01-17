import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';

class SwitchWidget extends StatelessWidget {
  const SwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit,HomeStates>(
      builder: (context, state) {
        var cubit= context.read<HomeCubit>();
        return Switch(
          inactiveThumbColor: ColorManager.primaryBlue,
          inactiveTrackColor: ColorManager.white.withOpacity(0.6),
          activeTrackColor: ColorManager.primaryBlue.withOpacity(0.8),
          activeColor: ColorManager.white,
          value: cubit.switchValue,
          onChanged: (bool value) => cubit.changeSwitchState(value: value),
        );
      },
    );
  }
}
