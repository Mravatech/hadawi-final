import 'package:dartz/dartz.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

abstract class VisitorsRepo {

  Future<Either<Faliure, void>> sendFollowRequest({
    required String userId,
    required String followerId,
    required String userName,
    required String image,
  });

}