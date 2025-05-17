import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/visitors_view_body.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';

class VisitorsScreen extends StatelessWidget {
  const VisitorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VisitorsCubit>(
      create: (context) => VisitorsCubit(getIt(),getIt(),getIt())..getOccasions(),
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: VisitorsViewBody(),
      ),
    );
  }
}
