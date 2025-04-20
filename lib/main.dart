import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/register_screen.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/occasion_summary.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_cubit.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/my_occasions.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_cubit.dart';
import 'package:hadawi_app/featuers/settings/presentation/view/widgets/notification_screen.dart';
import 'package:hadawi_app/featuers/settings/presentation/view/widgets/privacy_policies.dart';
import 'package:hadawi_app/featuers/splash/preentation/view/screen/splash_screen.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/visitors_screen.dart';
import 'package:hadawi_app/firebase_options.dart';
import 'package:hadawi_app/styles/theme_manger/theme_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/localiztion/localization_cubit.dart';
import 'package:hadawi_app/utiles/localiztion/localization_states.dart';
import 'package:hadawi_app/utiles/services/dio_helper.dart';
import 'package:hadawi_app/utiles/services/notification_service.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'featuers/visitors/presentation/view/widgets/occasion_details.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    // Add route for handling the problematic deep link format
    GoRoute(
      path: '/google/link',
      redirect: (context, state) => '/home',
    ),
    GoRoute(
      path: '/occasion-details/:id',
      builder: (context, state) {
        final occasionId = state.pathParameters['id'];
        return OccasionDetails(occasionId: occasionId!);
      },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => HomeLayout(),
    ),
    GoRoute(
      path: '/summary',
      builder: (context, state) => OccasionSummary(),
    ),
    GoRoute(
      path: '/visitors',
      builder: (context, state) => VisitorsScreen(),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => NotificationScreen(),
    ),
    GoRoute(
      path: '/privacy-policies',
      builder: (context, state) => PrivacyPoliciesScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/my-occasions',
      builder: (context, state) => MyOccasions(),
    ),
    GoRoute(path: '/sign-up', builder: (context, state) => const RegisterScreen()),
  ],
  // Add error handler for routes not found
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Route not found: ${state.uri}'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator().init();
  SharedPreferences.getInstance();
  CashHelper.init();
  DioHelper.dioInit();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService().initRemoteNotification();
  // NotificationService().getAccessToken();

  debugPrint("current date is ${DateTime.now()}");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance();
    UserDataFromStorage.getData();
    CashHelper.init();
    DioHelper.dioInit();
    _initDeepLinkHandling();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinkHandling() async {
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (error) {
        debugPrint('Deep link error: $error');
        // Navigate to a safe route when there's an error
        if (mounted) {
          context.go('/home');
        }
      },
    );

    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(Uri.parse(initialLink.toString()));
      } else {
        // Always provide a fallback route
        if (mounted) {
          context.go('/');
        }
      }
    } catch (e) {
      debugPrint('Error getting initial deep link: $e');
      // Navigate to a safe route when there's an exception
      if (mounted) {
        context.go('/');
      }
    }
  }

  void _handleDeepLink(Uri uri) {
    debugPrint('Received deep link: ${uri.toString()}');

    if (!mounted) return;

    // Handle Firebase Dynamic Links or custom scheme URLs
    if (uri.toString().contains('com.app.hadawiapp://google/link')) {
      // Extract parameters if needed
      // For now, just redirect to home
      context.go('/home');
      return;
    }

    // Handle standard path-based routing
    if (uri.pathSegments.isNotEmpty) {
      // Fix the casing issue - ensure we check for lowercase path segments
      if (uri.pathSegments.first.toLowerCase() == 'occasion-details' && uri.pathSegments.length > 1) {
        final occasionId = uri.pathSegments[1];
        context.go('/occasion-details/$occasionId');
      } else {
        // Fallback for unknown paths
        context.go('/home');
      }
    } else {
      // No path segments, go to default route
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(
            getIt(), getIt(), getIt(), getIt(),
            getIt(), getIt(), getIt(),
            getIt(), getIt(), getIt())),
        BlocProvider(create: (context) => PaymentCubit()),
        BlocProvider(create: (context) => HomeCubit()..getUserNotifications()..getPrivacyPolices()),
        BlocProvider(create: (context) => OccasionCubit()),
        BlocProvider(create: (context) => VisitorsCubit(getIt())..getAnalysis()),
        BlocProvider(create: (context) => OccasionsListCubit()),
        BlocProvider(create: (context) => LocalizationCubit()..fetchLocalization()),
      ],
      child: BlocBuilder<LocalizationCubit, LocalizationStates>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Hadawi',
            theme: getApplicationTheme(context),
            routerConfig: _router,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale("ar", ""),
              Locale("en", ""),
            ],
            locale: LocalizationCubit.get(context).appLocal,
            localeResolutionCallback: (currentLang, supportLang) {
              if (currentLang != null) {
                for (Locale locale in supportLang) {
                  if (locale.languageCode == currentLang.languageCode) {
                    return currentLang;
                  }
                }
              }
              return supportLang.first;
            },
          );
        },
      ),
    );
  }
}