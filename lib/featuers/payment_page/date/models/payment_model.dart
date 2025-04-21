class PaymentModel {
  final int paymentAmount;
  final String paymentDate;
  final String paymentId;
  final String paymentStatus;
  final String occasionId;
  final String occasionName;
  final String personId;
  final String personName;
  final String personPhone;
  final String personEmail;

  PaymentModel({
    required this.paymentAmount,
    required this.paymentDate,
    required this.paymentId,
    required this.paymentStatus,
    required this.occasionId,
    required this.occasionName,
    required this.personId,
    required this.personName,
    required this.personPhone,
    required this.personEmail,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> json) => PaymentModel(
    paymentAmount: json["paymentAmount"].runtimeType==double? json["paymentAmount"].toInt():json["paymentAmount"]??0,
    paymentDate: json["paymentDate"]??"",
    paymentId: json["paymentId"]??"",
    paymentStatus: json["paymentStatus"]??"",
    occasionId: json["occasionId"]??"",
    occasionName: json["occasionName"]??"",
    personId: json["personId"]??"",
    personName: json["personName"]??"",
    personPhone: json["personPhone"]??"",
    personEmail: json["personEmail"]??"",
  );

  Map<String, dynamic> toMap() => {
    "paymentAmount": paymentAmount??0,
    "paymentDate": paymentDate??"",
    "paymentId": paymentId??"",
    "paymentStatus": paymentStatus??"",
    "occasionId": occasionId??"",
    "occasionName": occasionName??"",
    "personId": personId??"",
    "personName": personName??"",
    "personPhone": personPhone??"",
    "personEmail": personEmail??"",
  };
}