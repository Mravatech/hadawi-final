import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/search_bar_widget.dart';

class VisitorsViewBody extends StatelessWidget {
  const VisitorsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitorsCubit,VisitorsState>(
      builder: (context, state) {
        return  Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SearchBarWidget(),
            ],
          ),
        );
      },
    );
  }
}
