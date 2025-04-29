class OccasionEntity {
  final bool isForMe;
  final String occasionName;
  final String occasionDate;
  final String occasionId;
  final String occasionType;
  final dynamic moneyGiftAmount;
  final String personId;
  final String personName;
  final String personPhone;
  final String personEmail;
  final String giftName;
  final String giftLink;
  final dynamic giftPrice;
  final List<dynamic> giftImage;
  final String giftType;
  final bool isSharing;
  final String receiverName;
  final String receiverPhone;
  final String bankName;
  final String ibanNumber;
  final bool isContainName;
  final String giftCard;
  final String city;
  final String district;
  final String note;
  final bool isPrivate;
  final bool isActive;
  final double discount;
  final double appCommission;
  final double deliveryPrice;
  final String type;

  OccasionEntity(
  {
    required this.isForMe,
    required this.occasionName,
    required this.isActive,
    required this.occasionDate,
    required this.occasionId,
    required this.occasionType,
    required this.moneyGiftAmount,
    required this.personId,
    required this.personName,
    required this.personPhone,
    required this.personEmail,
    required this.giftImage,
    required this.giftName,
    required this.giftLink,
    required this.giftPrice,
    required this.giftType,
    required this.isSharing,
    required this.receiverName,
    required this.receiverPhone,
    required this.bankName,
    required this.ibanNumber,
    required this.isContainName,
    required this.giftCard,
    required this.city,
    required this.district,
    required this.note,
    required this.isPrivate,
    required this.discount,
    required this.appCommission,
    required this.deliveryPrice,
    required this.type,
  });
}
