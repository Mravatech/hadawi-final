import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;



//  push to new screen under bottom bar
Future<void> customPushNavigator(context ,Widget page) async {
  if (kIsWeb) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
    );
  }
  else{
    if(Platform.isAndroid){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
    if(Platform.isIOS){
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => page),
      );
    }
  }
}


//  push to new screen under bottom bar
Future<void> customPushNavigatorFullScreen(context ,Widget page) async {
  if (kIsWeb) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
    );
  }
  else{
    if(Platform.isAndroid){
      Navigator.of(context,rootNavigator: true).push(
        MaterialPageRoute(
          maintainState: true,
          fullscreenDialog: false,
          builder: (BuildContext context) => page,
        ),
      );
    }
    if(Platform.isIOS){
      Navigator.of(context,rootNavigator: true).push(
        CupertinoPageRoute(
          maintainState: true,
          fullscreenDialog: false,
          builder: (BuildContext context) => page,
        ),
      );
    }
  }
}



//  push to new screen and remove all screens route before
Future<void> customPushAndRemoveUntil(context ,Widget page)async {

  if (kIsWeb) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
          (Route<dynamic> route) => false,
    );
  }

  else{
    if(Platform.isAndroid){
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute<bool>(
          maintainState: false,
          builder: (BuildContext context) => page,
        ),(Route<dynamic> route) => false,
      );
    }

    if(Platform.isIOS){
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        CupertinoPageRoute<bool>(
          maintainState: false,
          builder: (BuildContext context) => page,
        ),(Route<dynamic> route) => false,
      );
    }

  }



}

Future<void> customPushNavigatorAndNotChangeContent(context ,Widget page) async {
  if (kIsWeb) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
    );
  }
  else{
    if(Platform.isAndroid){
      Navigator.push(
        context,
        MaterialPageRoute(
          maintainState: false,
          fullscreenDialog: false,
          builder: (context) => page,
        ),
      );
    }
    if(Platform.isIOS){
      Navigator.push(
        context,
        MaterialPageRoute(
          maintainState: false,
          fullscreenDialog: false,
          builder: (context) => page,
        ),
      );
    }
  }
}

Future<void> customPushNavigatorFullAndroidWay(context ,Widget page) async {
  if (kIsWeb) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
    );
  }
  else{
    Navigator.of(context,rootNavigator: true).push(
      MaterialPageRoute(
        maintainState: true,
        fullscreenDialog: true,
        builder: (BuildContext context) => page,
      ),
    );
  }

}

Future<void>  customPushReplacement(context ,Widget page,)async {

  if (kIsWeb) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
    );
  }
  else{
    if(Platform.isAndroid){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }

    if(Platform.isIOS){
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => page),
      );
    }

  }
}

/// replace current screen by new screen under bottom bar
Future<void> customPushReplacementDeleteRoute(context ,Widget page,)async {

  if (kIsWeb) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
    );
  }
  else{
    if(Platform.isAndroid){
      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }

    if(Platform.isIOS){
      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => page),
      );
    }

  }
}


/// replace current screen by new screen under bottom bar
Future<void> customPushReplacementDeleteAd(context ,Widget page,)async {

  if (kIsWeb) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
    );
  }
  else{
    if(Platform.isAndroid){
      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }

    if(Platform.isIOS){
      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => page),
      );
    }

  }
}
