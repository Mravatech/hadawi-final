import 'package:dartz/dartz.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

abstract class VisitorsRepo {

  Future<Either<Faliure, void>> sendFollowRequest({
    required String userId,
    required String followerId,
    required String userName,
    required String image,
  });
  Future<Either<Faliure, bool>> updateOccasion({
    required String occasionId,
    String? occasionName,
    String? occasionDate,
    String? occasionType,
    double? moneyGiftAmount,
    String? personName,
    String? personPhone,
    String? personEmail,
    String? giftName,
    String? giftLink,
    double? giftPrice,
    String? giftType,
    String? bankName,
    String? city,
    String? district,
    String? giftCard,
    String? ibanNumber,
    String? receiverName,
    String? receiverPhone,
    String? receivingDate,
    List<String>? giftImages,
  });

}