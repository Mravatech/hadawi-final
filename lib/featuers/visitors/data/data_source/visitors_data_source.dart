import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';

import '../../../../utiles/error_handling/exceptions/exceptions.dart';
import '../../../../utiles/error_handling/faliure/faliure.dart';
import '../../../friends/data/models/followers_model.dart';

abstract class VisitorsDataSource {
  Future<void> sendFollowRequest({
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
    List<String>? giftImages,
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
  });
}

class VisitorsDataSourceImplement implements VisitorsDataSource {
    @override
    Future<void> sendFollowRequest({
      required String userId,
      required String followerId,
      required String userName,
      required String image,
    }) async {
      FollowersModel followersModel = FollowersModel(
        userId: userId,
        userName: userName,
        image: image,
        follow: false,
      );

      FollowersModel toFollowing = FollowersModel(
        userId: followerId,
        userName: UserDataFromStorage.userNameFromStorage,
        image: image,
        follow: false,
      );

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followerId)
            .collection('followers')
            .doc(userId)
            .set(followersModel.toMap());

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('following')
            .doc(followerId)
            .set(toFollowing.toMap());
      } on FirebaseException catch (e) {
        throw FireStoreException(firebaseException: e);
      } on Exception catch (e) {
        throw Exception(e.toString());
      }
    }

  @override
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
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('Occasions')
          .doc(occasionId)
          .update({
        'occasionName': occasionName,
        'occasionDate': occasionDate,
        'occasionType': occasionType,
        'moneyGiftAmount': moneyGiftAmount,
        'personName': personName,
        'personPhone': personPhone,
        'personEmail': personEmail,
        'giftName': giftName,
        'giftLink': giftLink,
        'giftPrice': giftPrice,
        'giftType': giftType,
        'bankName': bankName,
        'city': city,
        'district': district,
        'giftCard': giftCard,
        'ibanNumber': ibanNumber,
        'receiverName': receiverName,
        'receiverPhone': receiverPhone,
        'receivingDate': receivingDate
      });

      return const Right(true);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }
}
