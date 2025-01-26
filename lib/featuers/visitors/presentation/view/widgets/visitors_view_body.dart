import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_card.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_details.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/search_bar_widget.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/visitors_home_shimmer.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../styles/colors/color_manager.dart';
import '../../../../../utiles/shared_preferences/shared_preference.dart';

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
          child: Column(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.15,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)
                      ),
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://img.freepik.com/free-photo/watercolor-gift-card-illustration_23-2151912036.jpg?t=st=1737894355~exp=1737897955~hmac=c642672a986fba67b3321c10c3db7e2e39f2faef06d8faa677b7e5871b097aa6&w=360'),
                          opacity: .3),
                    ),
                    height: MediaQuery.sizeOf(context).height * 0.19,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.sizeOf(context).height * 0.02,
                        horizontal:
                            MediaQuery.sizeOf(context).width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.06,
                        ),
                        Text(
                          ' ${UserDataFromStorage.userNameFromStorage} مرحباً',
                          style: TextStyles.textStyle18Medium
                              .copyWith(color: ColorManager.black),
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SearchBarWidget(),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.1),
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
        );
      },
    );
  }
}
