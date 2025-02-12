import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/constants/app_constants.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/tutorial_coach_widget.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit,HomeStates>(
      builder: (context, state) {
        var cubit = context.read<HomeCubit>();
        return SalomonBottomBar(
          backgroundColor: ColorManager.gray.withOpacity(0.5),
          currentIndex: cubit.currentIndex,
          onTap: (index)=> cubit.changeIndex(index: index),
          items: [

            /// Profile
            SalomonBottomBarItem(
              unselectedColor: Colors.black38,
              icon: Icon(Icons.home),
              title: Text(AppLocalizations.of(context)!.translate(AppConstants().homeLayoutTitles[cubit.currentIndex]).toString()),
              selectedColor: ColorManager.primaryBlue,
            ),

            /// Occaisons
            SalomonBottomBarItem(
              unselectedColor: Colors.black38,
              icon: Icon(Icons.add_circle_rounded),
              title:  Text(AppLocalizations.of(context)!.translate(AppConstants().homeLayoutTitles[cubit.currentIndex]).toString()),
              selectedColor: ColorManager.primaryBlue,
            ),

            /// Friends
            SalomonBottomBarItem(
              unselectedColor: Colors.black38,
              icon: Icon(Icons.people),
              title: Text(AppLocalizations.of(context)!.translate(AppConstants().homeLayoutTitles[cubit.currentIndex]).toString()),
              selectedColor: ColorManager.primaryBlue,
            ),

            /// Settings
            SalomonBottomBarItem(
              unselectedColor: Colors.black38,
              icon: Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.translate(AppConstants().homeLayoutTitles[cubit.currentIndex]).toString()),
              selectedColor: ColorManager.primaryBlue,
            ),
          ],
        );
      },
    );
  }
}
