import 'package:flutter/cupertino.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/profile_screen.dart';

class AppConstants{

  List<String> homeLayoutTitles=[
    'الرئيسية',
    'اضافه مناسبه',
    'البروفيل',
    'الاعدادت'
  ];

  List<Widget> homeLayoutWidgets=[
    ProfileScreen(),
    ProfileScreen(),
    ProfileScreen(),
    ProfileScreen(),
  ];
}