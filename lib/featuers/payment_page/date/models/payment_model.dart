class PaymentModel {
  final int paymentAmount;
  final String paymentDate;
  final String paymentId;
  final String paymentStatus;
  final String occasionId;
  final String occasionName;
  final String payerName;
  final String personId;
  final String personName;
  final String personPhone;
  final String personEmail;
  final String transactionId;

  PaymentModel({
    required this.paymentAmount,
    required this.paymentDate,
    required this.paymentId,
    required this.paymentStatus,
    required this.occasionId,
    required this.occasionName,
    required this.payerName,
    required this.personId,
    required this.personName,
    required this.personPhone,
    required this.personEmail,
    required this.transactionId,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> json) => PaymentModel(
    paymentAmount: json["paymentAmount"].runtimeType==double? json["paymentAmount"].toInt():json["paymentAmount"]??0,
    paymentDate: json["paymentDate"]??"",
    paymentId: json["paymentId"]??"",
    paymentStatus: json["paymentStatus"]??"",
    occasionId: json["occasionId"]??"",
    occasionName: json["occasionName"]??"",
    payerName: json["payerName"]??"",
    personId: json["personId"]??"",
    personName: json["personName"]??"",
    personPhone: json["personPhone"]??"",
    personEmail: json["personEmail"]??"",
    transactionId: json["transactionId"]??"",
  );

  Map<String, dynamic> toMap() => {
    "paymentAmount": paymentAmount??0,
    "paymentDate": paymentDate??"",
    "paymentId": paymentId??"",
    "paymentStatus": paymentStatus??"",
    "occasionId": occasionId??"",
    "occasionName": occasionName??"",
    "personId": personId??"",
    "payerName": payerName??"",
    "personName": personName??"",
    "personPhone": personPhone??"",
    "personEmail": personEmail??"",
    "transactionId": transactionId??"",
  };
}