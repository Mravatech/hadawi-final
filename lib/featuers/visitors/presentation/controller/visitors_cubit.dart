import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/friends/domain/entities/follower_entities.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/get_followers_use_cases.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/get_following_use_cases.dart';
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
  VisitorsCubit(this.sendFollowRequestUseCases, this.getFollowingUseCases,
      this.getFollowersUseCases)
      : super(VisitorsInitial());

  SendFollowRequestUseCases sendFollowRequestUseCases;
  GetFollowingUseCases getFollowingUseCases;
  GetFollowersUseCases getFollowersUseCases;

  List<OccasionEntity> activeOccasions = [];
  List<CompleteOccasionModel> doneOccasions = [];
  List<CompleteOccasionModel> myOrderOccasions = [];

  TextEditingController editOccasionNameController = TextEditingController();
  TextEditingController editGiftNameController = TextEditingController();
  TextEditingController editPersonNameController = TextEditingController();
  TextEditingController remainingBalanceController = TextEditingController();
  final searchKey = GlobalKey();

  bool isActive=false;

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
    doneOccasions=[];
    emit(GetOccasionsLoadingState());
    final result = await OccasionRepoImp().getOccasions();
    result.fold((failure) {
      emit(GetOccasionsErrorState(error: failure.message));
    }, (occasion) async {
      activeOccasions.clear();
      doneOccasions.clear();
      myOrderOccasions.clear();
      getFollowers(userId: UserDataFromStorage.uIdFromStorage);
      getFollowing(userId: UserDataFromStorage.uIdFromStorage);

      for (var element in occasion) {

        if (element.isActive == false &&
            (element.giftPrice).toInt() <= (element.moneyGiftAmount).toInt() && DateTime.now().isAfter(DateTime.parse(element.occasionDate))) {
          closeCount = closeCount + 1;
        } else {
          openCount = openCount + 1;
        }



        print('Element is private ${element.occasionDate}');
        if (element.isPrivate == false) {

          if (element.isActive == true && double.parse(element.giftPrice.toString()) >
                  double.parse(element.moneyGiftAmount.toString()) && DateTime.now().isBefore(DateTime.parse(element.occasionDate))) {
            activeOccasions.add(element);
          } else {

            print('this occasion is done ${element.occasionId}');
            var res = await FirebaseFirestore.instance
                .collection('Occasions')
                .doc(element.occasionId)
                .collection('receivedOccasions')
                .get();
            emit(GetOccasionsStillLoadingState());
            if (res.docs.isNotEmpty) {
              // doneOccasions
              //     .add(CompleteOccasionModel.fromJson(res.docs[0].data()));
              if (res.docs[0].data()['personId'] ==
                  UserDataFromStorage.uIdFromStorage) {
                myOrderOccasions
                    .add(CompleteOccasionModel.fromJson(res.docs[0].data()));
              }
            }
          }
        } else if (element.isPrivate == true) {
          if (element.isActive == true && DateTime.now().isAfter(DateTime.parse(element.occasionDate)) && DateTime.now().isBefore(DateTime.parse(element.occasionDate))
              && double.parse(element.giftPrice.toString()) >
                  double.parse(element.moneyGiftAmount.toString()) &&
              (followers
                      .where(
                          (followers) => followers.userId == element.personId)
                      .isNotEmpty ||
                  following
                      .where(
                          (following) => following.userId == element.personId)
                      .isNotEmpty)) {
            activeOccasions.add(element);
          }
        }


          if ( double.parse(element.giftPrice.toString()) > double.parse(element.moneyGiftAmount.toString()) && DateTime.now().isBefore(DateTime.parse(element.occasionDate)) ) {
          } else {
            print('this occasion is done ${element.occasionName}');
            var res = await FirebaseFirestore.instance
                .collection('Occasions')
                .doc(element.occasionId)
                .collection('receivedOccasions')
                .get();
            if (res.docs.isNotEmpty) {
              doneOccasions
                  .add(CompleteOccasionModel.fromJson(res.docs[0].data()));
              if (element.personId ==
                  UserDataFromStorage.uIdFromStorage) {
                myOrderOccasions
                    .add(CompleteOccasionModel.fromJson(res.docs[0].data()));
              }
            }

        }



      }
      await FirebaseFirestore.instance
          .collection('analysis')
          .doc('x6cWwImrRB3PIdVfcHnP')
          .update({'closeOccasions': closeCount, 'openOccasions': openCount});
      print('All close $closeCount open $openCount ');

      activeOccasions.sort((a, b) => convertStringToDateTime(b.occasionDate)
          .compareTo(convertStringToDateTime(a.occasionDate)));
      emit(GetOccasionsSuccessState(activeOccasions: activeOccasions, doneOccasions: doneOccasions));
      print('Done getting occasions ==>: ${doneOccasions.length}');
      print('Active getting occasions ==>: ${activeOccasions.length}');
    });
  }

  Future<void> lanuchToUrl(String url) async {
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

  List<OccasionEntity> searchOccasionsList = [];

  void search(String query) {
    searchOccasionsList.clear();
    emit(SearchLoadingState());
    print("search query: $query");
    activeOccasions.forEach((element) {
      print("occasion name: ${element.type}");
    });
    searchOccasionsList.addAll(activeOccasions.where((occasion) =>
        occasion.type.toLowerCase().contains(query.toLowerCase())));
    emit(SearchSuccessState(occasions: searchOccasionsList));
  }

  Future<void> sendFollowRequest(
      {required String userId,
      required String followerId,
      required String userName,
      required String image}) async {
    emit(SendFollowRequestLoadingState());
    var response = await sendFollowRequestUseCases.call(
        userId: userId,
        followerId: followerId,
        userName: userName,
        image: image);

    response.fold((l) => emit(SendFollowRequestErrorState(message: l.message)),
        (r) => emit(SendFollowRequestSuccessState()));
  }

  bool isActiveOrders = true;

  void changeActiveOrders(bool value) {
    isActiveOrders = value;
    emit(ChangeActiveOrdersState());
  }

  List<BannerModel> banners = [];

  Future<void> getBannerData() async {
    banners.clear();
    emit(GetBannerDataLoadingState());
    debugPrint('Getting banner data...');

    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Banners').get();
      debugPrint('Got ${querySnapshot.docs.length} banners from Firebase');
      
      for (var doc in querySnapshot.docs) {
        debugPrint('Banner data: ${doc.data()}');
        banners.add(BannerModel.fromMap(doc.data()));
      }
      
      debugPrint('Processed ${banners.length} banners');
      emit(GetBannerDataSuccessState());
    } catch (error) {
      debugPrint("Error in getting banner data: $error");
      emit(GetBannerDataErrorState());
    }
  }

  OccasionModel emptyOccasionModel = OccasionModel(
    isForMe: false,
    isActive: false,
    occasionName: '',
    occasionDate: '',
    occasionId: '',
    occasionType: '',
    moneyGiftAmount: 0.0,
    personId: '',
    personName: '',
    personPhone: '',
    personEmail: '',
    giftImage: [],
    giftName: '',
    giftLink: '',
    giftPrice: 0.0,
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
    packageImage: '',
    packagePrice: '',
    amountForEveryone: '0',
  );

  OccasionModel occasionDetailsModel = OccasionModel(
    isForMe: false,
    isActive: false,
    occasionName: '',
    occasionDate: '',
    occasionId: '',
    occasionType: '',
    moneyGiftAmount: 0.0,
    personId: '',
    personName: '',
    personPhone: '',
    personEmail: '',
    giftImage: [],
    giftName: '',
    giftLink: '',
    giftPrice: 0.0,
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
    packageImage: '',
    packagePrice: '',
    amountForEveryone: '0',
  );

  Future<void> getOccasionData({required String occasionId})async{
    emit(GetOccasionDataLoadingState());
    FirebaseFirestore.instance.collection('Occasions').doc(occasionId).get().then((value) {
      occasionDetailsModel = OccasionModel.fromJson(value.data()!);
      checkIsOccasionActive(occasionDetailsModel.isActive);
      debugPrint("occasionModel: ${occasionDetailsModel!.occasionName}");
      emit(GetOccasionDataSuccessState());
    }).catchError((error){
      debugPrint("error in getting occasion data: $error");
      emit(GetOccasionDataErrorState());
    });
  }

  String occasionLink = '';

  Future<String> createDynamicLink(String occasionId) async {
    emit(CreateOccasionLinkDetailsLoadingState());

    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://hadawiapp.page.link',
        // Make this path consistent with how you're handling it
        link: Uri.parse('https://hadawiapp.page.link/occasion-details/$occasionId'),
        androidParameters: const AndroidParameters(
          packageName: 'com.app.hadawi_app',
          minimumVersion: 1,
        ),
        iosParameters: const IOSParameters(
          bundleId: 'com.app.hadawiapp',
          minimumVersion: '1.0.0',
          appStoreId: '6742405578',
        ),
        // Adding social metadata for better link previews
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Hadawi App - Occasion Details',
          description: 'View this occasion in the Hadawi App',
        ),
      );

      final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      debugPrint("shortLink: ${shortLink.shortUrl}");
      occasionLink = shortLink.shortUrl.toString();
      emit(CreateOccasionLinkDetailsSuccessState());return shortLink.shortUrl.toString();
    } catch (error) {
      debugPrint("Error creating dynamic link: $error");
      emit(CreateOccasionLinkDetailsErrorState());
      return '';
    }
  }

  AnalysisModel? analysisModel;

  Future<void> getAnalysis() async {
    emit(GetAnalysisLoadingState());

    await FirebaseFirestore.instance
        .collection('analysis')
        .doc('x6cWwImrRB3PIdVfcHnP')
        .get()
        .then((value) {
      analysisModel = AnalysisModel.fromMap(value.data()!);
      emit(GetAnalysisSuccessState());
    }).catchError((error) {
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

  List<PaymentModel> myPaymentsList = [];

  Future<void> getMyPayments() async {
    myPaymentsList.clear();
    emit(GetMyPaymentLoadingState());
    try {
      var res = await FirebaseFirestore.instance.collection('payments').get();

      res.docs.forEach((element) {
        if (element.data()['personId'] == UserDataFromStorage.uIdFromStorage) {
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

  List<FollowerEntities> followers = [];
  List<FollowerEntities> followersRequest = [];

  Future<void> getFollowers({
    required String userId,
  }) async {
    followers = [];
    emit(FollowersLoadingState());
    var response = await getFollowersUseCases.call(
      userId: userId,
    );
    response.fold((l) => emit(FollowersErrorState(message: l.message)), (r) {
      for (var element in r) {
        if (element.follow == false) {
        } else {
          followers.add(element);
        }
      }
      emit(FollowersSuccessState());
    });
  }

  List<FollowerEntities> following = [];

  Future<void> getFollowing({
    required String userId,
  }) async {
    following = [];
    followersRequest = [];
    emit(FollowingLoadingState());
    var response = await getFollowingUseCases.call(
      userId: userId,
    );
    response.fold((l) => emit(FollowingErrorState(message: l.message)), (r) {
      for (var element in r) {
        print('Elemnet flow ${element.follow}');
        if (element.follow == true) {
          following.add(element);
        } else {
          followersRequest.add(element);
        }
      }
      emit(FollowingSuccessState());
    });
  }

  bool checkIsOccasionActive(bool value ){
    emit(IsActiveLoading());
    isActive = value;
    emit(IsActiveSuccess());
    return isActive;
  }
}
