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
  final String giftImage;
  final String giftType;
  final bool isSharing;

  OccasionEntity(
  {
    required this.isForMe,
    required this.occasionName,
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
    required this.isSharing
  });
}
