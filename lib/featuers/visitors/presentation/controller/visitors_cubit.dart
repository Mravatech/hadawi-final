import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/occasions/data/models/analysis_model.dart';
import 'package:hadawi_app/featuers/occasions/data/models/complete_occasion_model.dart';
import 'package:hadawi_app/featuers/occasions/data/models/occasion_model.dart';
import 'package:hadawi_app/featuers/occasions/data/repo_imp/occasion_repo_imp.dart';
import 'package:hadawi_app/featuers/payment_page/date/models/payment_model.dart';
import 'package:hadawi_app/featuers/visitors/data/models/banner_model.dart';
import 'package:hadawi_app/featuers/visitors/domain/use_cases/send_follow_request_use_cases.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../occasions/domain/entities/occastion_entity.dart';
part 'visitors_state.dart';

class VisitorsCubit extends Cubit<VisitorsState> {
  VisitorsCubit(this.sendFollowRequestUseCases) : super(VisitorsInitial());

  SendFollowRequestUseCases sendFollowRequestUseCases;


  List<OccasionEntity> activeOccasions = [];
  List<CompleteOccasionModel> doneOccasions = [];
  List<CompleteOccasionModel> myOrderOccasions = [];

  TextEditingController editOccasionNameController = TextEditingController();
  TextEditingController editGiftNameController = TextEditingController();
  TextEditingController editPersonNameController = TextEditingController();
  TextEditingController remainingBalanceController = TextEditingController();
  final searchKey = GlobalKey();

  convertStringToDateTime(String dateString) {
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
      myOrderOccasions.clear();

      for (var element in occasion) {
        if(element.isActive==false && (element.giftPrice).toInt() <= (element.moneyGiftAmount).toInt()){
          closeCount =closeCount + 1;
        }else{
          openCount =openCount + 1;
        }
        if(element.isPrivate == false ){
          if (element.isActive==true && double.parse(element.giftPrice.toString()) > double.parse(element.moneyGiftAmount.toString())) {
            activeOccasions.add(element);
          } else {
            print('this occasion is done ${element.occasionId}');
            var res = await FirebaseFirestore.instance
                .collection('Occasions')
                .doc(element.occasionId)
                .collection('receivedOccasions')
                .get();
            if (res.docs.isNotEmpty) {
              doneOccasions
                  .add(CompleteOccasionModel.fromJson(res.docs[0].data()));
              if (res.docs[0].data()['personId'] ==
                  UserDataFromStorage.uIdFromStorage) {
                myOrderOccasions
                    .add(CompleteOccasionModel.fromJson(res.docs[0].data()));
              }
            }
          }
        }
      }
      await FirebaseFirestore.instance.collection('analysis').doc('x6cWwImrRB3PIdVfcHnP').update({
        'closeOccasions': closeCount,
        'openOccasions': openCount
      });
      print('All close $closeCount open $openCount ');

      activeOccasions.sort((a, b) => convertStringToDateTime(b.occasionDate).compareTo(convertStringToDateTime(a.occasionDate)));
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
    print("search query: $query");
    activeOccasions.forEach((element) {
      print("occasion name: ${element.type}");
    });
    searchOccasionsList.addAll(activeOccasions.where((occasion) => occasion.type.toLowerCase().contains(query.toLowerCase())));
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

  OccasionModel occasionModel = OccasionModel(
    isForMe: false,
    isActive: false,
    occasionName: '',
    occasionDate: '',
    occasionId: '',
    occasionType: '',
    moneyGiftAmount: '',
    personId: '',
    personName: '',
    personPhone: '',
    personEmail: '',
    giftImage: [],
    giftName: '',
    giftLink: '',
    giftPrice: '',
    giftType: '',
    isSharing: false,
    receiverName: '',
    receiverPhone: '',
    bankName: '',
    ibanNumber: '',
    isContainName: false,
    giftCard: '',
    city: '',
    district: '',
    note: '',
    isPrivate: false,
    discount: 0.0,
    appCommission: 0.0,
    deliveryPrice: 0.0,
    type: '',
  );

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
        bundleId: 'com.app.hadawiapp',
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
  List<OccasionModel> myOccasionsList = [];

  Future<void> editOccasion({
    required String occasionId,
    String? occasionName,
    String? personName,
    String? giftName,
  }) async {
    emit(EditOccasionLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('Occasions')
          .doc(occasionId)
          .update({
        'occasionName': occasionName,
        'personName': personName,
        'giftName': giftName,
      });

      await getOccasions();

        emit(EditOccasionSuccessState());

    } catch (e) {
      debugPrint("error when edit occasion: ${e.toString()}");
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }


    Future<void> lanuchToUrl(String url) async {
      final Uri uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

  List<PaymentModel> myPaymentsList = [];
  Future<void> getMyPayments() async {
    myPaymentsList.clear();
    emit(GetMyPaymentLoadingState());
    try {
      var res = await FirebaseFirestore.instance
          .collection('payments')
          .get();

      res.docs.forEach((element) {
        if(element.data()['personId']==UserDataFromStorage.uIdFromStorage){
          myPaymentsList.add(PaymentModel.fromMap(element.data()));
        }
      });

      emit(GetMyPaymentSuccessState());

    } catch (e) {
      debugPrint("error when edit occasion: ${e.toString()}");
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }



}
