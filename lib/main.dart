import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/occasion_screen.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_cubit.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/profile_screen.dart';
import 'package:hadawi_app/featuers/splash/preentation/view/screen/splash_screen.dart';
import 'package:hadawi_app/firebase_options.dart';
import 'package:hadawi_app/styles/theme_manger/theme_manager.dart';
import 'package:hadawi_app/utiles/services/dio_helper.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'featuers/occasions_list/presentation/view/my_occasions.dart';
import 'featuers/occasions_list/presentation/view/others_occasions.dart';
import 'featuers/payment_page/presentation/view/payment_screen.dart';
import 'utiles/shared_preferences/shared_preference.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator().init();
  SharedPreferences.getInstance();
  UserDataFromStorage.getData();
  DioHelper.dioInit();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
              getIt(), getIt(), getIt(),
              getIt(), getIt(), getIt(),
          )),
          BlocProvider(create: (context)=> PaymentCubit()),
        ],
        child: BlocBuilder<AuthCubit,AuthStates>(
          builder: (context, state) {
            return  MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Hadawi',
              theme: getApplicationTheme(context),
              home: const SplashScreen(),
            );
          },
        )
    );
  }
}


