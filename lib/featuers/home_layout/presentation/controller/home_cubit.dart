import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';

class HomeCubit extends Cubit<HomeStates> {

  HomeCubit() : super(HomeInitialState());

  int currentIndex=0;
  final homeKey = GlobalKey();
  final activeOrdersKey = GlobalKey();
  final completeOrdersKey = GlobalKey();
  final searchKey = GlobalKey();
  final languageKey = GlobalKey();
  final logoutKey = GlobalKey();

  void changeIndex({required int index}){
    currentIndex=index;
    emit(HomeChangeIndexState());
  }

  bool switchValue=false;
  void changeSwitchState({required bool value}){
    switchValue=value;
    emit(ChangeSwitchState());
  }


}