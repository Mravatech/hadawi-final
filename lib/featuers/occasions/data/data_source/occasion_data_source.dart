import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hadawi_app/featuers/occasions/data/models/occasion_model.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';

class OccasionDataSource {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<OccasionModel> getOccasion() async {
    final doc = await fireStore.collection('Occasions').doc().get();
    return OccasionModel.fromJson(doc.data()!);
  }

  Future<OccasionModel> addOccasion({
    required String id,
    required bool isForMe,
    required String occasionName,
    required String occasionDate,
    required String occasionId,
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
  }) async {
    OccasionModel occasionModel = OccasionModel(
      id: id,
      isForMe: isForMe,
      occasionName: occasionName,
      occasionDate: occasionDate,
      occasionId: occasionId,
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
    );
    try {
      await fireStore.collection('Occasions').doc().set(occasionModel.toJson());
      return occasionModel;
    } on FireStoreException catch (e) {
      throw FireStoreException(firebaseException: e.firebaseException);
    }
  }
}
