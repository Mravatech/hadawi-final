import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/occasions/data/data_source/occasion_data_source.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/occasions/domain/repo/occasion_repo.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

class OccasionRepoImp extends OccasionRepo {
  @override
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
      required receiverName,
      required receiverPhone,
      required bankName,
      required ibanNumber,
      required isContainName,
      required giftCard,
      required city,
      required district,
      required note,
      required isPrivate,
      required discount,
      required appCommission,
      required deliveryPrice,
      required type,
      required packageImage,
      required packagePrice,
      required amountForEveryone,

      }) async {
    final result = await OccasionDataSource().addOccasion(
        isForMe: isForMe,
        isActive: isActive,
        occasionName: occasionName,
        occasionDate: occasionDate,
        occasionType: occasionType,
        moneyGiftAmount: moneyGiftAmount,
        personId: personId,
        personName: personName,
        personPhone: personPhone,
        personEmail: personEmail,
        giftImage: giftImage,
        giftName: giftName,
        giftLink: giftLink,
        giftPrice: giftPrice,
        giftType: giftType,
        isSharing: isSharing,
        receiverName: receiverName,
        receiverPhone: receiverPhone,
        bankName: bankName,
        ibanNumber: ibanNumber,
        isContainName: isContainName,
        giftCard: giftCard,
        city: city,
        district: district,
        note: note,
        isPrivate: isPrivate,
        discount: discount,
        appCommission: appCommission,
        deliveryPrice: deliveryPrice,
        type: type,
        packageImage: packageImage,
        packagePrice: packagePrice,
        amountForEveryone: amountForEveryone,
    );
    try {
      return Right(result);
    } on Exception catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, List<OccasionEntity>>> getOccasions() async {
    final result = await OccasionDataSource().getAllOccasions();
    try {
      return Right(result);
    } on Exception catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }
}
