import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_card.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_details.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/search_bar_widget.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/visitors_home_shimmer.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class VisitorsViewBody extends StatelessWidget {
  const VisitorsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitorsCubit, VisitorsState>(
      builder: (context, state) {
        final mediaQuery = MediaQuery.sizeOf(context);
        final cubit = context.read<VisitorsCubit>();
        return ModalProgressHUD(
          inAsyncCall: state is GetOccasionsLoadingState,
          progressIndicator: VisitorsHomeShimmer(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SearchBarWidget(),
                SizedBox(
                  height: mediaQuery.height * 0.02,
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            customPushNavigator(
                                context,
                                BlocProvider(
                                  create: (context) => VisitorsCubit(),
                                  child: OccasionDetails(
                                    occasionEntity: cubit.occasions[index],
                                  ),
                                ));
                          },
                          child: OccasionCard(
                            index: index,
                          ));
                    },
                    itemCount: cubit.occasions.length,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
