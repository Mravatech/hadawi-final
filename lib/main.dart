import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/register_screen.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/bloc_observer.dart';
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
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_details.dart';
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
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => const LoginScreen(),
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(
      path: '/occasion-details/:id/:fromHome',
      name: 'occasion-details',
      builder: (context, state) {
        final occasionId = state.pathParameters['id'];
        final fromHome = state.pathParameters['fromHome'] == 'true';
        debugPrint('Opening occasion details for ID: $occasionId, fromHome: $fromHome');
        return OccasionDetails(occasionId: occasionId!, fromHome: fromHome);
      },
    ),
    GoRoute(path: '/home', builder: (context, state) => HomeLayout()),
    GoRoute(path: '/summary', builder: (context, state) => OccasionSummary()),
    GoRoute(path: '/visitors', builder: (context, state) => VisitorsScreen()),
    GoRoute(path: '/notification', builder: (context, state) => NotificationScreen()),
    GoRoute(path: '/privacy-policies', builder: (context, state) => PrivacyPoliciesScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/my-occasions', builder: (context, state) => MyOccasions()),
    GoRoute(path: '/sign-up', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/:path(.*)', builder: (context, state) => const LoginScreen()),
  ],
);


Future<void> main() async {
  await SentryFlutter.init(
        (options) {
      options.dsn = 'https://84d149a4ed2f407b023cd9ca435bab0c@o4509321210494981.ingest.de.sentry.io/4509321270788176';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () async {
      WidgetsFlutterBinding.ensureInitialized();

      ServiceLocator().init();
      await SharedPreferences.getInstance();
      await CashHelper.init();
      UserDataFromStorage.getData();
      DioHelper.dioInit();
      Bloc.observer = MyBlocObserver();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Initialize Firebase Dynamic Links
      final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

      if (initialLink != null) {
        debugPrint('Initial dynamic link: ${initialLink.link}');
        _handleDynamicLink(initialLink);
      }

      // Listen for dynamic links while the app is running
      FirebaseDynamicLinks.instance.onLink.listen(
            (dynamicLinkData) {
          debugPrint('Dynamic link received while app running: ${dynamicLinkData.link}');
          _handleDynamicLink(dynamicLinkData);
        },
        onError: (error) {
          debugPrint('Dynamic link error: $error');
        },
      );

      FlutterError.onError = (details) {
        if (details.exception.toString().contains('HttpException') &&
            details.exception.toString().contains('Invalid statusCode: 404')) {
          return;
        }
        Sentry.captureException(details.exception, stackTrace: details.stack);
        FlutterError.presentError(details);
      };

      await NotificationService().initRemoteNotification();

      runApp(const MyApp());
    },
  );
}

// Function to handle dynamic links
void _handleDynamicLink(PendingDynamicLinkData dynamicLinkData) {
  final Uri deepLink = dynamicLinkData.link;
  debugPrint('Handling dynamic link: $deepLink');

  // Extract occasion ID from the link
  String? occasionId;

  // Check for both formats:
  // 1. https://hadawiapp.page.link/occasion-details/{occasionId}
  // 2. https://hadawiapp.page.link/?link=https://hadawiapp.page.link/occasion-details/{occasionId}

  if (deepLink.pathSegments.isNotEmpty) {
    // Handle path segments
    int occasionDetailsIndex = deepLink.pathSegments.indexOf('occasion-details');
    if (occasionDetailsIndex != -1 && occasionDetailsIndex < deepLink.pathSegments.length - 1) {
      occasionId = deepLink.pathSegments[occasionDetailsIndex + 1];
    } else if (deepLink.pathSegments.length >= 2 &&
        deepLink.pathSegments[0] == 'occasion-details') {
      occasionId = deepLink.pathSegments[1];
    }

    // Handle custom schemes like hadawi://occasion-details/{id}
    if (occasionId == null && deepLink.pathSegments.isNotEmpty) {
      occasionId = deepLink.pathSegments.last;
    }
  }

  // Check query parameters (for ?link= format)
  if (occasionId == null && deepLink.queryParameters.containsKey('link')) {
    final linkParam = Uri.tryParse(deepLink.queryParameters['link']!);
    if (linkParam != null && linkParam.pathSegments.isNotEmpty) {
      final segments = linkParam.pathSegments;
      int occasionDetailsIndex = segments.indexOf('occasion-details');
      if (occasionDetailsIndex != -1 && occasionDetailsIndex < segments.length - 1) {
        occasionId = segments[occasionDetailsIndex + 1];
      } else if (segments.length >= 2 && segments[0] == 'occasion-details') {
        occasionId = segments[1];
      }
    }
  }

  // For short links like https://hadawiapp.page.link/b7Hr
  // Check if there's an ID in the path or in the last segment
  if (occasionId == null && deepLink.pathSegments.isNotEmpty) {
    final lastSegment = deepLink.pathSegments.last;
    if (lastSegment.isNotEmpty && lastSegment != 'occasion-details') {
      // This might be a short link with the ID as the last segment
      occasionId = lastSegment;
    }
  }

  debugPrint('Extracted occasion ID: $occasionId');

  if (occasionId != null && occasionId.isNotEmpty) {
    // Navigate to occasion details using global navigation context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyApp.navigatorKey.currentState?.context.go('/occasion-details/$occasionId/true');
    });
  }
}

class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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
    _initAppLinksHandling();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
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
    }

    debugPrint('Extracted occasion ID from app link: $occasionId');

    if (occasionId != null && occasionId.isNotEmpty) {
      // Use GoRouter to navigate
      if (mounted) {
        GoRouter.of(context).go('/occasion-details/$occasionId/true');
      }
    } else {
      // Default navigation if no occasion ID is found
      if (mounted) {
        final isLoggedIn = UserDataFromStorage.userIsGuest;
        GoRouter.of(context).go(isLoggedIn ? '/home' : '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(
            getIt(), getIt(), getIt(), getIt(),
            getIt(), getIt(), getIt(),
            getIt(), getIt(), getIt())..getAllCity()),
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
            supportedLocales: const [Locale("ar", ""), Locale("en", "")],
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