import 'package:flutter/cupertino.dart';
import 'package:hadawi_app/featuers/friends/presentation/view/friends_screen.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/occasion_screen.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/profile_screen.dart';
import 'package:hadawi_app/featuers/settings/presentation/view/settings_screen.dart';

class AppConstants{

  List<String> homeLayoutTitles=[
    'الرئيسية',
    'اضافه مناسبه',
    'البروفيل',
    'الاعدادت'
  ];

  List<Widget> homeLayoutWidgets=[
    ProfileScreen(),
    OccasionScreen(),
    ProfileScreen(),
    SettingScreen(),
  ];
}