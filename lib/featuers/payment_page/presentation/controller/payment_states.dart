abstract class PaymentStates{}

class PaymentInitialState extends PaymentStates{}

class PaymentCounterChangedState extends PaymentStates{}

class PaymentAddLoadingState extends PaymentStates{}
class PaymentAddSuccessState extends PaymentStates{}
class PaymentAddErrorState extends PaymentStates{}

class PaymentGetLoadingState extends PaymentStates{}
class PaymentGetSuccessState extends PaymentStates{}
class PaymentGetErrorState extends PaymentStates{}