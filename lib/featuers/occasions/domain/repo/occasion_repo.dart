import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

abstract class OccasionRepo {
  Future<Either<Faliure, List<OccasionEntity>>> getOccasions();

  Future<Either<Faliure, OccasionEntity>> addOccasions(
      {
      required bool isForMe,
          required bool isActive,
      required String occasionName,
      required String occasionDate,
      required String occasionType,
      required int moneyGiftAmount,
      required String personId,
      required String personName,
      required String personPhone,
      required String personEmail,
      required List<String> giftImage,
      required String giftName,
      required String giftLink,
      required double giftPrice,
      required String giftType,
      required bool isSharing,
      required String receiverName,
      required String receiverPhone,
      required String bankName,
      required String ibanNumber,
      required bool isContainName,
      required String giftCard,
      required String city,
      required String district,
      required String note,
      required String type,
      required bool isPrivate,
      required double discount,
      required double appCommission,
      required double deliveryPrice,
      required String packageImage,
      required String packagePrice,
      required amountForEveryone,
      });
}
