import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/data/models/occasion_model.dart';
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
        Set<String> addedOccasionIds = {}; // Track added occasion IDs to prevent duplicates
        
        for (var element in value.docs) {
          // Only include occasions that are for others (isForMe == false) and are active and not fully funded
          if(element["isForMe"] == false && 
             element['personId'] == UserDataFromStorage.uIdFromStorage &&
             element['isActive'] == true && 
             element['giftPrice'].toInt() > element['moneyGiftAmount'].toInt()){
            
            // Check if we've already added this occasion ID to prevent duplicates
            String occasionId = element.id;
            if (!addedOccasionIds.contains(occasionId)) {
              othersOccasionsList.add(OccasionModel.fromJson(element.data()));
              addedOccasionIds.add(occasionId);
              debugPrint("Added others occasion: ${element['type']} with ID: $occasionId");
            } else {
              debugPrint("Skipped duplicate others occasion: ${element['type']} with ID: $occasionId");
            }
          }
        }
      });
      debugPrint("Final othersOccasionsList count: ${othersOccasionsList.length}");
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
        Set<String> addedOccasionIds = {}; // Track added occasion IDs to prevent duplicates
        
        for (var element in value.docs) {
          // Only include occasions that are for me (isForMe == true) and are active and not fully funded
          if(element['personId'] == UserDataFromStorage.uIdFromStorage && 
             element['isActive'] == true && 
             element['giftPrice'].toInt() > element['moneyGiftAmount'].toInt() &&
             element['isForMe'] == true){
            
            // Check if we've already added this occasion ID to prevent duplicates
            String occasionId = element.id;
            if (!addedOccasionIds.contains(occasionId)) {
              myOccasionsList.add(OccasionModel.fromJson(element.data()));
              addedOccasionIds.add(occasionId);
              debugPrint("element[''] ${OccasionModel.fromJson(element.data())}");
              debugPrint("Added occasion: ${element['type']} with ID: $occasionId");
            } else {
              debugPrint("Skipped duplicate occasion: ${element['type']} with ID: $occasionId");
            }
          }
        }
      });
      myOccasionsList.forEach((element) {
        print('element.occasionDate ${element.giftImage}' );
      });
      debugPrint("Final occasionsList count: ${myOccasionsList.length}");
      debugPrint("myOccasionsList ${myOccasionsList.map((e) => e.toJson()).toList()}");
      emit(GetMyOccasionListSuccessState());
    } catch (e) {
      debugPrint("error when get my occasion : ${e.toString()}");
      emit(GetMyOccasionListErrorState());
    }
  }

  Future<void> getPastOccasionsList() async {
    pastOccasionsList = [];
    emit(GetPastOccasionListLoadingState());
    try {await FirebaseFirestore.instance.collection('Occasions').get().then((value){
        for (var element in value.docs) {
          if(element['giftPrice'].toInt() <= element['moneyGiftAmount'].toInt() && element['personId'] == UserDataFromStorage.uIdFromStorage){
            print("element['isActive'] ${element['isActive']}");
            pastOccasionsList.add(OccasionModel.fromJson(element.data()));
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
    try {await FirebaseFirestore.instance.collection('Occasions').get().then((value){
        for (var element in value.docs) {
          print("element['isActive'] ${element['isActive']}");
          if(element['isActive'] ==false && element['personId'] == UserDataFromStorage.uIdFromStorage){
            closedOccasionsList.add(OccasionModel.fromJson(element.data()));
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

  bool privateAccount= UserDataFromStorage.isPrivateAccount;

  void changePrivateAccount(){
    privateAccount = !privateAccount;
    FirebaseFirestore.instance.collection('users').doc(UserDataFromStorage.uIdFromStorage).update({
      'private': privateAccount,
    }).then((value) {
      UserDataFromStorage.setPrivateAccount(privateAccount);
    });
    emit(ChangePrivateAccountState());
  }




}