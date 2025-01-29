import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/occasions/data/repo_imp/occasion_repo_imp.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../occasions/domain/entities/occastion_entity.dart';
part 'visitors_state.dart';

class VisitorsCubit extends Cubit<VisitorsState> {
  VisitorsCubit() : super(VisitorsInitial());


  List<OccasionEntity> occasions = [];

  TextEditingController searchController = TextEditingController();
  Future<void> getOccasions() async {
    emit(GetOccasionsLoadingState());
    final result = await OccasionRepoImp().getOccasions();
    result.fold((failure) {
      emit(GetOccasionsErrorState(error: failure.message));
    }, (occasion) {
      occasions.addAll(occasion);
      emit(GetOccasionsSuccessState(occasions: occasions));
    });
  }
  Future<void> openExerciseLink(String url) async {
    try {
      final Uri uri = Uri.parse(Uri.encodeFull(url)); // Ensure proper encoding

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Open in external browser
        );
      } else {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching $url: $e');
    }
  }
  List<OccasionEntity> searchOccasionsList=[];

  void search(String query) {
    searchOccasionsList.clear();
    emit(SearchLoadingState());
    searchOccasionsList.addAll(occasions.where((occasion) => occasion.occasionName.toLowerCase().contains(query.toLowerCase())));
    debugPrint('searchOccasionsList ${searchOccasionsList[0].occasionName}');
    emit(SearchSuccessState(occasions: searchOccasionsList));
  }

}
