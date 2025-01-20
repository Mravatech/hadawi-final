import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';

class OccasionModel extends OccasionEntity {
  OccasionModel(
      {required super.id,
      required super.isForMe,
      required super.occasionName,
      required super.occasionDate,
      required super.occasionId,
      required super.occasionType,
      required super.moneyGiftAmount,
      required super.personId,
      required super.personName,
      required super.personPhone,
      required super.personEmail,
      required super.giftImage,
      required super.giftName,
      required super.giftLink,
      required super.giftPrice,
      required super.giftType});

  factory OccasionModel.fromJson(Map<String, dynamic> json) => OccasionModel(
        id: json['id'],
        isForMe: json['isForMe'],
        occasionName: json['occasionName'],
        occasionDate: json['occasionDate'],
        occasionId: json['occasionId'],
        occasionType: json['occasionType'],
        moneyGiftAmount: json['moneyGiftAmount'],
        personId: json['personId'],
        personName: json['personName'],
        personPhone: json['personPhone'],
        personEmail: json['personEmail'],
        giftImage: json['occasionImage'],
        giftName: json['giftName'],
        giftLink: json['giftLink'],
        giftPrice: json['giftPrice'],
        giftType: json['giftType'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'isForMe': isForMe,
        'occasionName': occasionName,
        'occasionDate': occasionDate,
        'occasionId': occasionId,
        'occasionType': occasionType,
        'moneyGiftAmount': moneyGiftAmount,
        'personId': personId,
        'personName': personName,
        'personPhone': personPhone,
        'personEmail': personEmail,
        'occasionImage': giftImage,
        'giftName': giftName,
        'giftLink': giftLink,
        'giftPrice': giftPrice,
        'giftType': giftType
      };
}
