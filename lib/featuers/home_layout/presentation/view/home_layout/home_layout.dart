import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/constants/app_constants.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit,HomeStates>(
        builder: (context, state) {
          var cubit = context.read<HomeCubit>();
          return Scaffold(
            backgroundColor: ColorManager.white,
            appBar: AppBar(
              title: Text(
                  AppConstants().homeLayoutTitles[cubit.currentIndex],
                  style: TextStyles.textStyle18Bold
              ),
            ),
            body:  Center(
              child: Text(
                  AppConstants().homeLayoutTitles[cubit.currentIndex],
                  style: TextStyles.textStyle18Bold
              ),
            ),
            bottomNavigationBar: SalomonBottomBar(
              backgroundColor: ColorManager.gray.withOpacity(0.5),
              currentIndex: cubit.currentIndex,
              onTap: (index)=> cubit.changeIndex(index: index),
              items: [

                /// Profile
                SalomonBottomBarItem(
                  unselectedColor: Colors.black38,
                  icon: Icon(Icons.home),
                  title: Text("Profile"),
                  selectedColor: ColorManager.primaryBlue,
                ),

                /// Occaisons
                SalomonBottomBarItem(
                  unselectedColor: Colors.black38,
                  icon: Icon(Icons.add_circle_rounded),
                  title: Text("Occaisons"),
                  selectedColor: ColorManager.primaryBlue,
                ),

                /// Friends
                SalomonBottomBarItem(
                  unselectedColor: Colors.black38,
                  icon: Icon(Icons.people),
                  title: Text("Friends"),
                  selectedColor: ColorManager.primaryBlue,
                ),

                /// Settings
                SalomonBottomBarItem(
                  unselectedColor: Colors.black38,
                  icon: Icon(Icons.settings),
                  title: Text("Settings"),
                  selectedColor: ColorManager.primaryBlue,
                ),
              ],
            ),
          );
        },
      )
    );
  }
}
