import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/settings/data/models/notification_model.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';

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


  // get user notifications
  List<NotificationModel> notifications=[];
  Future<void> getUserNotifications()async{

    emit(GetUserNotificationsLoadingState());
    notifications=[];

    FirebaseFirestore.instance.collection('notifications').get().then((value) {
      value.docs.forEach((element) {
        if(UserDataFromStorage.uIdFromStorage==element.data()['userId']){
          notifications.add(NotificationModel.fromMap(element.data()));
        }
      });
      emit(GetUserNotificationsSuccessState());
    }).catchError((error){
      debugPrint("error in getting user notifications: $error");
      emit(GetUserNotificationsErrorState());
    });

  }

  // get privacy_policies

  String privacyPolicies='';

  Future<void> getPrivacyPolices ()async{
    emit(GetAppPrivacyPoliciesLoadingState());
    FirebaseFirestore.instance.collection('privacy_policies').get().then((value) {
      privacyPolicies = value.docs[0]['text'];
      debugPrint("privacy policies: $privacyPolicies");
      emit(GetAppPrivacyPoliciesSuccessState());
    }).catchError((error){
      debugPrint("error in getting Privacy Policies : $error");
      emit(GetAppPrivacyPoliciesErrorState());
    });
  }

  Future<void> getToken({required String uId})async {
    
    String? token = await FirebaseMessaging.instance.getToken();
    print('token: $token');
    print('userId: $uId');
    UserDataFromStorage.setGradeAdmin(true);
    FirebaseFirestore.instance.collection('users').doc(uId).update({'token': token});
    emit(GetTokenSuccessState());
  }


  Future<void> launchWhatsApp()
  async {
    final phoneNumber = '+966564940300';
    final message = 'مرحبًا، أحتاج إلى مساعدة من فريق الدعم الفني. من فضلكم تواصلوا معي.';
    final Uri whatsappUri = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }




}