import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/constants/app_constants.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/tutorial_coach_widget.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toastification_widget.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:toastification/toastification.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        var cubit = context.read<HomeCubit>();
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: ColorManager.primaryBlue.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SalomonBottomBar(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.zero,
                itemPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                currentIndex: cubit.currentIndex,
                onTap: (index) async {
                  cubit.changeIndex(index: index);
                  context.read<OccasionCubit>().resetData();
                },
                items: [
                  _buildNavItem(
                    context: context,
                    icon: Icons.home_rounded,
                    index: 0,
                    currentIndex: cubit.currentIndex,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.add_circle_rounded,
                    index: 1,
                    currentIndex: cubit.currentIndex,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.people_rounded,
                    index: 2,
                    currentIndex: cubit.currentIndex,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.settings_rounded,
                    index: 3,
                    currentIndex: cubit.currentIndex,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  SalomonBottomBarItem _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required int index,
    required int currentIndex,
  }) {
    final bool isSelected = index == currentIndex;
    return SalomonBottomBarItem(
      icon: Icon(
        icon,
        size: isSelected ? 28 : 24,
      ),
      title: Text(
        AppLocalizations.of(context)!
            .translate(AppConstants().homeLayoutTitles[index])
            .toString(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      selectedColor: ColorManager.primaryBlue,
      unselectedColor: Colors.grey.shade400,
    );
  }
}
