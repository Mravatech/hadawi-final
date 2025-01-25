class OccasionModel {
  final String giftLink;
  final String giftName;
  final int giftPrice;
  final String giftType;
  final bool isForMe;
  final bool isSharing;
  final String moneyGiftAmount;
  final String occasionDate;
  final String occasionId;
  final String occasionImage;
  final String occasionName;
  final String occasionType;
  final String personEmail;
  final String personId;
  final String personName;

  OccasionModel({
    required this.giftLink,
    required this.giftName,
    required this.giftPrice,
    required this.giftType,
    required this.isForMe,
    required this.isSharing,
    required this.moneyGiftAmount,
    required this.occasionDate,
    required this.occasionId,
    required this.occasionImage,
    required this.occasionName,
    required this.occasionType,
    required this.personEmail,
    required this.personId,
    required this.personName,
  });

  factory OccasionModel.fromMap(Map<String, dynamic> json) => OccasionModel(
    giftLink: json["giftLink"]??'',
    giftName: json["giftName"]??'',
    giftPrice: json["giftPrice"]??0,
    giftType: json["giftType"]??'',
    isForMe: json["isForMe"]??false,
    isSharing: json["isSharing"]??false,
    moneyGiftAmount: json["moneyGiftAmount"]??'',
    occasionDate: json["occasionDate"]??'',
    occasionId: json["occasionId"]??'',
    occasionImage: json["occasionImage"]??'',
    occasionName: json["occasionName"]??'',
    occasionType: json["occasionType"]??'',
    personEmail: json["personEmail"]??'',
    personId: json["personId"]??'',
    personName: json["personName"]??'',
  );

  Map<String, dynamic> toMap() => {
    "giftLink": giftLink,
    "giftName": giftName,
    "giftPrice": giftPrice,
    "giftType": giftType,
    "isForMe": isForMe,
    "isSharing": isSharing,
    "moneyGiftAmount": moneyGiftAmount,
    "occasionDate": occasionDate,
    "occasionId": occasionId,
    "occasionImage": occasionImage,
    "occasionName": occasionName,
    "occasionType": occasionType,
    "personEmail": personEmail,
    "personId": personId,
    "personName": personName,
  };
}