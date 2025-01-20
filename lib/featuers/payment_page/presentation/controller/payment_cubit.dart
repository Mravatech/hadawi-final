import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_states.dart';

class PaymentCubit extends Cubit<PaymentStates> {

  PaymentCubit() : super(PaymentInitialState());

  static PaymentCubit get(context) => BlocProvider.of(context);

  int paymentCounterValue = 10;


  void incrementCounter() {
    paymentCounterValue++;
    emit(PaymentCounterChangedState());
  }

  void decrementCounter() {
    paymentCounterValue--;
    emit(PaymentCounterChangedState());
  }

}