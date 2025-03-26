import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/occasions/data/models/analysis_model.dart';
import 'package:hadawi_app/featuers/occasions/data/models/occasion_model.dart';
import 'package:hadawi_app/featuers/occasions/data/repo_imp/occasion_repo_imp.dart';
import 'package:hadawi_app/featuers/visitors/data/models/banner_model.dart';
import 'package:hadawi_app/featuers/visitors/domain/use_cases/send_follow_request_use_cases.dart';
import 'package:share_plus/share_plus.dart';
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
  int closeCount=0;
  int openCount=0;
  Future<void> getOccasions() async {
    closeCount=0;
    openCount=0;
    emit(GetOccasionsLoadingState());
    final result = await OccasionRepoImp().getOccasions();
    result.fold((failure) {
      emit(GetOccasionsErrorState(error: failure.message));
    }, (occasion)async {
      activeOccasions.clear();
      doneOccasions.clear();

      for (var element in occasion) {
        if((element.giftPrice).toInt() <= (element.moneyGiftAmount).toInt()){
          closeCount =closeCount + 1;
        }else{
          openCount =openCount + 1;
        }
        if(element.isPrivate == false){
          if (double.parse(element.giftPrice.toString()) > double.parse(element.moneyGiftAmount.toString())) {
            activeOccasions.add(element);
          } else {
            doneOccasions.add(element);
          }
        }
      }
      await FirebaseFirestore.instance.collection('analysis').doc('x6cWwImrRB3PIdVfcHnP').update({
        'closeOccasions': closeCount,
        'openOccasions': openCount
      });
      print('All close $closeCount open $openCount ');

      activeOccasions.sort((a, b) => convertStringToDateTime(b.occasionDate).compareTo(convertStringToDateTime(a.occasionDate)));
      doneOccasions.sort((a, b) => convertStringToDateTime(b.occasionDate).compareTo(convertStringToDateTime(a.occasionDate)));
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

  List<BannerModel> banners = [];

  Future<void> getBannerData()async{
    banners.clear();
    emit(GetBannerDataLoadingState());

    FirebaseFirestore.instance.collection('Banners').get().then((value) {
      value.docs.forEach((element) {
        banners.add(BannerModel.fromMap(element.data()));
      });
      emit(GetBannerDataSuccessState());
    }).catchError((error){
      debugPrint("error in getting banner data: $error");
      emit(GetBannerDataErrorState());
    });

  }

  OccasionModel? occasionModel;

  Future<void> getOccasionData({required String occasionId})async{
    emit(GetOccasionDataLoadingState());
    FirebaseFirestore.instance.collection('Occasions').doc(occasionId).get().then((value) {
      occasionModel = OccasionModel.fromJson(value.data()!);
      debugPrint("occasionModel: ${occasionModel!.occasionName}");
      emit(GetOccasionDataSuccessState());
    }).catchError((error){
      debugPrint("error in getting occasion data: $error");
      emit(GetOccasionDataErrorState());
    });
  }

  Future<String> createDynamicLink(String occasionId) async {
    emit(CreateOccasionLinkDetailsLoadingState());
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://hadawiapp.page.link',
      link: Uri.parse('https://hadawiapp.page.link/Occasion-details/$occasionId'),
      androidParameters: const AndroidParameters(
        packageName: 'com.app.hadawi_app',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.app.hadawiApp',
        minimumVersion: '1.0.0',
      ),
    );

    final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    debugPrint("shortLink: ${shortLink.shortUrl}");
    emit(CreateOccasionLinkDetailsSuccessState());
    return shortLink.shortUrl.toString();
  }

  AnalysisModel ?analysisModel ;
  Future<void> getAnalysis()async{

    emit(GetAnalysisLoadingState());

    await FirebaseFirestore.instance.collection('analysis').doc('x6cWwImrRB3PIdVfcHnP').get().then((value) {
      analysisModel = AnalysisModel.fromMap(value.data()!);
      emit(GetAnalysisSuccessState());
    }).catchError((error){
      debugPrint("error in getting analysis: $error");
      emit(GetAnalysisErrorState());
    });

  }


}
