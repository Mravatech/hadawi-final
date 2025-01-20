import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/occasion_screen.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/visitors_screen.dart';
import 'package:hadawi_app/firebase_options.dart';
import 'package:hadawi_app/styles/theme_manger/theme_manager.dart';
import 'package:hadawi_app/utiles/services/dio_helper.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hadawi',
      theme: getApplicationTheme(context),
      home: const VisitorsScreen(),
    );
  }
}


