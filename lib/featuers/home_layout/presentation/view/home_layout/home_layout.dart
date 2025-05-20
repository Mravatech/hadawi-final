import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/constants/app_constants.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/widgets/bottom_navigation_bar_widget.dart';
import 'package:hadawi_app/main.dart';
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
  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;


  @override
  void initState() {
    super.initState();
    _initAppLinksHandling();
    if(UserDataFromStorage.userIsGuest==false ){
      context.read<HomeCubit>().getToken(uId: UserDataFromStorage.uIdFromStorage);
    }
  }


  Future<void> _initAppLinksHandling() async {
    // Handle app links (for universal links and custom schemes)
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleAppLink,
      onError: (error) {
        debugPrint('App link error: $error');
      },
    );

    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        debugPrint('Initial app link: $initialLink');
        _handleAppLink(initialLink);
      }
    } catch (e) {
      debugPrint('Error getting initial app link: $e');
    }
  }

  void _handleAppLink(Uri uri) {
    debugPrint('Received app link: $uri');

    // Extract occasion ID from app link
    String? occasionId;

    // Handle various URI formats
    if (uri.scheme == 'hadawi' || uri.scheme == 'com.app.hadawiapp') {
      // Custom scheme URI: hadawi://occasion-details/{id}
      if (uri.host == 'occasion-details' && uri.pathSegments.isNotEmpty) {
        occasionId = uri.pathSegments.first;
      }
    } else if (uri.host == 'hadawiapp.page.link') {
      // Firebase Dynamic Link
      if (uri.pathSegments.isNotEmpty) {
        if (uri.pathSegments.contains('occasion-details')) {
          int idx = uri.pathSegments.indexOf('occasion-details');
          if (idx < uri.pathSegments.length - 1) {
            occasionId = uri.pathSegments[idx + 1];
          }
        } else if (uri.pathSegments.length > 0) {
          // This might be a short link, treat the last segment as the ID
          occasionId = uri.pathSegments.last;
        }
      }

      // Check if a link parameter is provided
      if (occasionId == null && uri.queryParameters.containsKey('link')) {
        final linkUri = Uri.tryParse(uri.queryParameters['link']!);
        if (linkUri != null) {
          // Extract ID from the link parameter
          if (linkUri.pathSegments.contains('occasion-details')) {
            int idx = linkUri.pathSegments.indexOf('occasion-details');
            if (idx < linkUri.pathSegments.length - 1) {
              occasionId = linkUri.pathSegments[idx + 1];
            }
          }
        }
      }
    }

    debugPrint('Extracted occasion ID from app link: $occasionId');

    if (occasionId != null && occasionId.isNotEmpty) {
      // Use WidgetsBinding to ensure the navigation happens after the widget tree is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Navigate using the standard Navigator and the navigatorKey
        MyApp.navigatorKey.currentState?.pushNamed(
            AppRoutes.occasionDetails,
            arguments: {
              'occasionId': occasionId,
              'fromHome': true
            }
        );
      });
    } else {
      // Default navigation if no occasion ID is found
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final isLoggedIn = UserDataFromStorage.userIsGuest;
        MyApp.navigatorKey.currentState?.pushReplacementNamed(
            isLoggedIn ? AppRoutes.home : AppRoutes.login
        );
      });
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
                  context: context
                    ),
              body: AppConstants().homeLayoutWidgets[cubit.currentIndex],
              bottomNavigationBar: BottomNavigationBarWidget(),
            );
          },
        ));

  }
}
