import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hadawi_app/featuers/occasions/data/models/occasion_model.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';

class OccasionDataSource {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<List<OccasionModel>> getAllOccasions() async {
    try {
      final querySnapshot = await fireStore.collection('Occasions').get();

      final occasions = querySnapshot.docs
          .map((doc) => OccasionModel.fromJson(doc.data()))
          .toList();

      return occasions;
    } catch (e) {
      throw Exception("Failed to fetch occasions: $e");
    }
  }

  Future<OccasionModel> addOccasion({
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
    required bool isSharing,
  }) async {
    final docRef = fireStore.collection('Occasions').doc();
    final occasionId = docRef.id;

    OccasionModel occasionModel = OccasionModel(
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
      isSharing: isSharing,
    );

    try {
      await docRef.set(occasionModel.toJson());
      return occasionModel;
    } on FireStoreException catch (e) {
      throw FireStoreException(firebaseException: e.firebaseException);
    }
  }

}
