class OccasionModel {
  final String giftLink;
  final String giftName;
  final dynamic giftPrice;
  final String giftType;
  final bool isForMe;
  final bool isSharing;
  final dynamic moneyGiftAmount;
  final String occasionDate;
  final String occasionId;
  final List<dynamic> occasionImage;
  final String occasionName;
  final String occasionType;
  final String personEmail;
  final String personId;
  final String personName;
  final String personPhone;
  final String receiverName;
  final String receiverPhone;
  final String bankName;
  final String ibanNumber;
  final String receivingDate;
  final bool isContainName;
  final String giftCard;
  final String city;
  final String district;
  final String note;
  final bool isPrivate;
  final double discount;
  final double appCommission;
  final double deliveryPrice;

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
    required this.personPhone,
    required this.receiverName,
    required this.receiverPhone,
    required this.bankName,
    required this.ibanNumber,
    required this.receivingDate,
    required this.isContainName,
    required this.giftCard,
    required this.city,
    required this.district,
    required this.note,
    required this.isPrivate,
    required this.discount,
    required this.appCommission,
    required this.deliveryPrice,
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
    personPhone: json["personPhone"]??'',
    receiverName: json["receiverName"]??'',
    receiverPhone: json["receiverPhone"]??'',
    bankName: json["bankName"]??'',
    ibanNumber: json["ibanNumber"]??'',
    receivingDate: json["receivingDate"]??'',
    isContainName: json["isContainName"]??false,
    giftCard: json["giftCard"]??'',
    city: json["city"]??'',
    district: json["district"]??'',
    note: json["note"]??'',
    isPrivate: json["isPrivate"]??false,
    discount: json["discount"]??0.0,
    appCommission: json["appCommission"]??0.0,
    deliveryPrice: json["deliveryPrice"]??0.0,
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
    "personPhone": personPhone,
    "receiverName": receiverName,
    "receiverPhone": receiverPhone,
    "bankName": bankName,
    "ibanNumber": ibanNumber,
    "receivingDate": receivingDate,
    "isContainName": isContainName,
    "giftCard": giftCard,
    "city": city,
    "district": district,
    "note": note,
    "isPrivate": isPrivate,
    "discount": discount,
    "appCommission": appCommission,
    "deliveryPrice": deliveryPrice,
  };
}