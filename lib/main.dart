import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_cubit.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_cubit.dart';
import 'package:hadawi_app/featuers/splash/preentation/view/screen/splash_screen.dart';
import 'package:hadawi_app/firebase_options.dart';
import 'package:hadawi_app/styles/theme_manger/theme_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/localiztion/localization_cubit.dart';
import 'package:hadawi_app/utiles/localiztion/localization_states.dart';
import 'package:hadawi_app/utiles/services/dio_helper.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utiles/shared_preferences/shared_preference.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator().init();
  SharedPreferences.getInstance();
  UserDataFromStorage.getData();
  CashHelper.init();
  DioHelper.dioInit();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String languageCode = CashHelper.getData(key: CashHelper.languageKey).toString();
  debugPrint('debug $languageCode');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit(
              getIt(), getIt(), getIt(),getIt(),
              getIt(), getIt(), getIt(),
              getIt(), getIt(),
          )),
          BlocProvider(create: (context)=> PaymentCubit()),
          BlocProvider(create: (context)=> OccasionsListCubit()),
          BlocProvider(create: (context) => LocalizationCubit()..fetchLocalization()),
        ],
        child: BlocBuilder<LocalizationCubit,LocalizationStates>(
          builder: (context, state) {
            return  MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Hadawi',
              theme: getApplicationTheme(context),
              home: const SplashScreen(),
                localizationsDelegates:  [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale("en", ""),
                  Locale("ar", ""),
                ],
                locale: LocalizationCubit.get(context).appLocal,
                localeResolutionCallback: (currentLang , supportLang) {
                  if (currentLang != null) {
                    for (Locale locale in supportLang) {
                      if (locale.languageCode == currentLang.languageCode) {
                        return currentLang;
                      }
                    }
                  }
                  return supportLang.first;
                }
            );
          },
        )
    );
  }
}


