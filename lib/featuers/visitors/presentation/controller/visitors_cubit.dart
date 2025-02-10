import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/occasions/data/repo_imp/occasion_repo_imp.dart';
import 'package:hadawi_app/featuers/visitors/domain/use_cases/send_follow_request_use_cases.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../occasions/domain/entities/occastion_entity.dart';
part 'visitors_state.dart';

class VisitorsCubit extends Cubit<VisitorsState> {
  VisitorsCubit(this.sendFollowRequestUseCases) : super(VisitorsInitial());

  SendFollowRequestUseCases sendFollowRequestUseCases;


  List<OccasionEntity> activeOccasions = [];
  List<OccasionEntity> doneOccasions = [];
  final searchKey = GlobalKey();


  convertStringToDateTime(String dateString){
    DateTime dateTime = DateTime.parse(dateString);
    return dateTime;
  }

  TextEditingController searchController = TextEditingController();
  Future<void> getOccasions() async {
    emit(GetOccasionsLoadingState());
    final result = await OccasionRepoImp().getOccasions();
    result.fold((failure) {
      emit(GetOccasionsErrorState(error: failure.message));
    }, (occasion) {
      activeOccasions.clear();
      doneOccasions.clear();

      for (var element in occasion) {
        DateTime occasionDate = convertStringToDateTime(element.occasionDate);

        if (occasionDate.isAfter(DateTime.now()) && element.giftPrice > element.moneyGiftAmount) {
          activeOccasions.add(element);
        } else {
          doneOccasions.add(element);
        }
      }
      emit(GetOccasionsSuccessState(activeOccasions: activeOccasions, doneOccasions: doneOccasions));
    });
  }
  Future<void> openExerciseLink(String url) async {
    try {
      final Uri uri = Uri.parse(Uri.encodeFull(url)); // Ensure proper encoding

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Open in external browser
        );
      } else {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching $url: $e');
    }
  }
  List<OccasionEntity> searchOccasionsList=[];

  void search(String query) {
    searchOccasionsList.clear();
    emit(SearchLoadingState());
    searchOccasionsList.addAll(activeOccasions.where((occasion) => occasion.occasionName.toLowerCase().contains(query.toLowerCase())));
    debugPrint('searchOccasionsList ${searchOccasionsList[0].occasionName}');
    emit(SearchSuccessState(occasions: searchOccasionsList));

}

  Future<void> sendFollowRequest(
      {
        required String userId,
        required String followerId,
        required String userName,
        required String image
      })async{
    emit(SendFollowRequestLoadingState());
    var response = await sendFollowRequestUseCases.call(
        userId: userId,
        followerId: followerId,
        userName: userName,
        image: image
    );

    response.fold(
            (l)=>emit(SendFollowRequestErrorState(message: l.message)),
            (r)=>emit(SendFollowRequestSuccessState())
    );
  }

  bool isActiveOrders = true;

  void changeActiveOrders(bool value){
    isActiveOrders = value;
    emit(ChangeActiveOrdersState());
  }

}
