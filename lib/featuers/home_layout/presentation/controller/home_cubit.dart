import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';

class HomeCubit extends Cubit<HomeStates> {

  HomeCubit() : super(HomeInitialState());

  int currentIndex=0;

  void changeIndex({required int index}){
    currentIndex=index;
    emit(HomeChangeIndexState());
  }

}