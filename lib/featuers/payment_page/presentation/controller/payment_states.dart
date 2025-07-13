abstract class PaymentStates{}

class PaymentInitialState extends PaymentStates{}

class PaymentCounterChangedState extends PaymentStates{}

class PaymentAddLoadingState extends PaymentStates{}
class PaymentAddSuccessState extends PaymentStates{}
class PaymentAddErrorState extends PaymentStates{}

class PaymentGetLoadingState extends PaymentStates{}
class PaymentGetSuccessState extends PaymentStates{}
class PaymentGetErrorState extends PaymentStates{}

class PaymentHyperPayLoadingState extends PaymentStates{}
class PaymentHyperPaySuccessState extends PaymentStates{}
class PaymentHyperPayErrorState extends PaymentStates{}

class ApplyPaymentLoadingState extends PaymentStates{}
class ApplyPaymentSuccessState extends PaymentStates{}
class ApplyPaymentErrorState extends PaymentStates{}

class PaymentCreateLinkLoadingState extends PaymentStates{}
class PaymentCreateLinkSuccessState extends PaymentStates{}
class PaymentCreateLinkErrorState extends PaymentStates{}

class SendAppleTokenLoadingState extends PaymentStates{}
class SendAppleTokenSuccessState extends PaymentStates{}
class SendAppleTokenErrorState extends PaymentStates{}