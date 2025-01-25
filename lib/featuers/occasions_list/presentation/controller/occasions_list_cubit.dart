import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions_list/Data/Model/occasion_model.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_states.dart';

class OccasionsListCubit extends Cubit<OccasionsListStates> {

  OccasionsListCubit() : super(InitialOccasionsListState());

  static OccasionsListCubit get(context) => BlocProvider.of(context);


  List<OccasionModel> othersOccasionsList = [];
  List<OccasionModel> myOccasionsList = [];

  Future<void> getOthersOccasionsList() async {
    othersOccasionsList = [];
    emit(GetOthersOccasionListLoadingState());
    try {
      await FirebaseFirestore.instance.collection('Occasions').get().then((value){
        for (var element in value.docs) {
          if(element["isForMe"]== false){
            othersOccasionsList.add(OccasionModel.fromMap(element.data()));
          }
        }
      });
      debugPrint("occasionsList: $othersOccasionsList");
      emit(GetOthersOccasionListSuccessState());
    } catch (e) {
      debugPrint("error when get others occasion : ${e.toString()}");
      emit(GetOthersOccasionListErrorState());
    }
  }

  Future<void> getMyOccasionsList() async {
    myOccasionsList = [];
    emit(GetMyOccasionListLoadingState());
    try {
      await FirebaseFirestore.instance.collection('Occasions').get().then((value){
        for (var element in value.docs) {
          if(element["isForMe"]== true){
            myOccasionsList.add(OccasionModel.fromMap(element.data()));
          }
        }
      });
      debugPrint("occasionsList: $myOccasionsList");
      emit(GetMyOccasionListSuccessState());
    } catch (e) {
      debugPrint("error when get my occasion : ${e.toString()}");
      emit(GetMyOccasionListErrorState());
    }
  }




}