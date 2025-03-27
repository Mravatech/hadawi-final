import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/constants/app_constants.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/widgets/bottom_navigation_bar_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_app_bar_widget.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  void initState() {
    super.initState();
    if(UserDataFromStorage.userIsGuest==false && UserDataFromStorage.gradeAdminFromStorage!=true){
      context.read<HomeCubit>().getToken(uId: UserDataFromStorage.uIdFromStorage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeCubit(),
        child: BlocBuilder<HomeCubit, HomeStates>(
          builder: (context, state) {
            var cubit = context.read<HomeCubit>();
            return Scaffold(
              backgroundColor: ColorManager.white,
              appBar: cubit.currentIndex == 0
                  ? null
                  : defaultAppBarWidget(
                      appBarTitle:
                          AppLocalizations.of(context)!.translate(AppConstants().homeLayoutTitles[cubit.currentIndex]).toString(),
                    ),
              body: AppConstants().homeLayoutWidgets[cubit.currentIndex],
              bottomNavigationBar: BottomNavigationBarWidget(),
            );
          },
        ));

  }
}
