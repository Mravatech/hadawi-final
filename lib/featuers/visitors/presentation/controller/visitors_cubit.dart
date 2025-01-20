import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'visitors_state.dart';

class VisitorsCubit extends Cubit<VisitorsState> {
  VisitorsCubit() : super(VisitorsInitial());
}
