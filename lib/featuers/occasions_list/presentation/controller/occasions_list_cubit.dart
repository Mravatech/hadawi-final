import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions_list/Data/Model/occasion_model.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_states.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';

class OccasionsListCubit extends Cubit<OccasionsListStates> {

  OccasionsListCubit() : super(InitialOccasionsListState());

  static OccasionsListCubit get(context) => BlocProvider.of(context);


  List<OccasionModel> othersOccasionsList = [];
  List<OccasionModel> myOccasionsList = [];
  List<OccasionModel> pastOccasionsList = [];
  List<OccasionModel> closedOccasionsList = [];

  convertStringToDateTime(String dateString){
    DateTime dateTime = DateTime.parse(dateString);
    return dateTime;
  }

  Future<void> getOthersOccasionsList() async {
    othersOccasionsList = [];
    emit(GetOthersOccasionListLoadingState());
    try {
      await FirebaseFirestore.instance.collection('Occasions').get().then((value){
        for (var element in value.docs) {
          if(element["isForMe"]== false && convertStringToDateTime(element['occasionDate']).isAfter(DateTime.now())){
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
          if(element["isForMe"]== true && element['personId'] == UserDataFromStorage.uIdFromStorage && convertStringToDateTime(element['occasionDate']).isAfter(DateTime.now())){
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

  Future<void> getPastOccasionsList() async {
    pastOccasionsList = [];
    emit(GetPastOccasionListLoadingState());
    try {
      await FirebaseFirestore.instance.collection('Occasions').get().then((value){
        for (var element in value.docs) {
          if(DateTime.now().isAfter(convertStringToDateTime(element['occasionDate']))){
            pastOccasionsList.add(OccasionModel.fromMap(element.data()));
          }
        }
      });
      debugPrint("occasionsList past : $pastOccasionsList");
      emit(GetPastOccasionListSuccessState());
    } catch (e) {
      debugPrint("error when get past occasion : ${e.toString()}");
      emit(GetPastOccasionListErrorState());
    }
  }


  Future<void> getClosedOccasionsList() async {
    closedOccasionsList = [];
    emit(GetClosedOccasionListLoadingState());
    try {
      await FirebaseFirestore.instance.collection('Occasions').get().then((value){
        for (var element in value.docs) {
          if(convertStringToDateTime(element['occasionDate']).isAfter(DateTime.now()) && element['giftPrice'] >= int.parse(element['moneyGiftAmount'])){
            closedOccasionsList.add(OccasionModel.fromMap(element.data()));
          }
        }
      });
      debugPrint("occasionsList closed : $closedOccasionsList");
      emit(GetClosedOccasionListSuccessState());
    } catch (e) {
      debugPrint("error when get past occasion : ${e.toString()}");
      emit(GetClosedOccasionListErrorState());
    }
  }




}