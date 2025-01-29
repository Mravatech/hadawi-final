import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

abstract class OccasionRepo {
  Future<Either<Faliure, List<OccasionEntity>>> getOccasions();

  Future<Either<Faliure, OccasionEntity>> addOccasions(
      {
      required bool isForMe,
      required String occasionName,
      required String occasionDate,
      required String occasionType,
      required int moneyGiftAmount,
      required String personId,
      required String personName,
      required String personPhone,
      required String personEmail,
      required String giftImage,
      required String giftName,
      required String giftLink,
      required int giftPrice,
      required String giftType,
      required bool isSharing
      });
}
