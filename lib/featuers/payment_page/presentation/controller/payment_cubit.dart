import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/payment_page/date/models/payment_model.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_states.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';

class PaymentCubit extends Cubit<PaymentStates> {

  PaymentCubit() : super(PaymentInitialState());

  static PaymentCubit get(context) => BlocProvider.of(context);

  int paymentCounterValue = 50;


  void incrementCounter() {
    paymentCounterValue++;
    emit(PaymentCounterChangedState());
  }

  void decrementCounter() {
    paymentCounterValue--;
    emit(PaymentCounterChangedState());
  }
  
  
  Future<void> addPaymentData({required BuildContext context, required String occasionId, required String occasionName, required double paymentAmount})async{
    emit(PaymentAddLoadingState());

    await FirebaseFirestore.instance.collection("Occasions").doc(occasionId).update({
      "moneyGiftAmount": paymentAmount + paymentCounterValue,
    });

    await FirebaseFirestore.instance.collection("Occasions").doc(occasionId).collection("payments").add({
      "paymentAmount": paymentCounterValue,
      "paymentDate": DateTime.now().toString(),
      "paymentId": "",
      "paymentStatus": "success",
      "occasionId": occasionId,
      "occasionName": occasionName,
      "personId": UserDataFromStorage.uIdFromStorage,
      "personName": UserDataFromStorage.userNameFromStorage,
      "personPhone": UserDataFromStorage.phoneNumberFromStorage,
      "personEmail": UserDataFromStorage.emailFromStorage,
    }).then((value)async{
      await FirebaseFirestore.instance.collection("Occasions").doc(occasionId).collection("payments").doc(value.id).update({"paymentId": value.id});
      paymentCounterValue = 50;
      customToast(title: AppLocalizations.of(context)!.translate('paymentAddedSuccessfully').toString(), color: ColorManager.success);
      Navigator.pop(context);
      debugPrint("payment added");
      emit(PaymentAddSuccessState());
    }).catchError((error){
      debugPrint("error when add payment : ${error.toString()}");
      emit(PaymentAddErrorState());
    });
    
  }



  List<PaymentModel> occasionPaymentsList = [];


  Future<void> getOccasionPaymentsList({required String occasionId})async{
    occasionPaymentsList = [];
    emit(PaymentGetLoadingState());
    await FirebaseFirestore.instance.collection("Occasions").doc(occasionId).collection("payments").get().then((value)async{
      for (var element in value.docs) {
        occasionPaymentsList.add(PaymentModel.fromMap(element.data()));
      }
      debugPrint("payments got==> ${occasionPaymentsList.length}");
      emit(PaymentGetSuccessState());
    }).catchError((error){
      debugPrint("error when get payments : ${error.toString()}");
      emit(PaymentGetErrorState());
    });
  }


}