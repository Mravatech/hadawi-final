import 'package:dartz/dartz.dart';
import 'package:hadawi_app/featuers/visitors/data/data_source/visitors_data_source.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/error_handling/faliure/faliure.dart';

import '../../domain/repo/visitors_repo.dart';

class VisitorsRepoImplement extends VisitorsRepo {

  VisitorsDataSource visitorsDataSource;

  VisitorsRepoImplement({required this.visitorsDataSource});


  @override
  Future<Either<Faliure, void>> sendFollowRequest({
    required String userId,
    required String followerId,
    required String userName,
    required String image
  })async {
    try{
      return Right(await visitorsDataSource.sendFollowRequest(
          userId: userId,
          followerId: followerId,
          userName: userName,
          image: image
      ));
    }on FireStoreException catch(e){
      return Left(FireStoreFaliure.fromMessage(e));
    }on Exception catch(e){
      return Left(Faliure(message: e.toString()));
    }
  }

}