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
    required bool isPrivate,
    required double discount,
    required double appCommission,
    required double deliveryPrice,
    required String type,
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
    );

    try {
      await docRef.set(occasionModel.toJson());
      return occasionModel;
    } on FireStoreException catch (e) {
      throw FireStoreException(firebaseException: e.firebaseException);
    }
  }
}
