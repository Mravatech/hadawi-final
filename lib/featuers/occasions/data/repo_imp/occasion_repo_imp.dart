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
      required String occasionName,
      required String occasionDate,
      required String occasionType,
      required String moneyGiftAmount,
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
      }) async {
    final result = await OccasionDataSource().addOccasion(
        isForMe: isForMe,
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
