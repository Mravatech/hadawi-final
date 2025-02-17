import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/for_me_body.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/for_other_body.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/for_whom_row.dart';

class OccasionViewBody extends StatelessWidget {
  const OccasionViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    return BlocConsumer<OccasionCubit, OccasionState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<OccasionCubit>();
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ForWhomRow(),
                SizedBox(height: mediaQuery.height * 0.02),
                // cubit.selectedIndex==0? ForMeBody(): ForOtherBody()
                ForMeBody()
              ],
            ),
          ),
        );
      },
    );
  }
}
