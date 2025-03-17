import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_cubit.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_states.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/widgets/occasions_card.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_details.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/widgets/default_button_with_image.dart';

class ClosedOccasions extends StatefulWidget {
  const ClosedOccasions({super.key});

  @override
  State<ClosedOccasions> createState() => _ClosedOccasionsState();
}

class _ClosedOccasionsState extends State<ClosedOccasions> {
  @override
  void initState() {
    // TODO: implement initState
    OccasionsListCubit.get(context).getClosedOccasionsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.gray,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            AppLocalizations.of(context)!
                .translate('closedOccasions')
                .toString(),
            style: TextStyles.textStyle18Bold
                .copyWith(color: ColorManager.primaryBlue),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child:
                Image(image: AssetImage(AssetsManager.logoWithoutBackground)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.height * 0.02),
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.height * 0.02,
            ),
            BlocConsumer<OccasionsListCubit, OccasionsListStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return state is GetClosedOccasionListLoadingState
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Expanded(
                        child: state is GetClosedOccasionListSuccessState &&
                                OccasionsListCubit.get(context)
                                    .closedOccasionsList
                                    .isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  await OccasionsListCubit.get(context)
                                      .getClosedOccasionsList();
                                },
                                child: GridView.builder(
                                  physics: BouncingScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // Number of columns
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio: 0.9,
                                  ),
                                  itemCount: OccasionsListCubit.get(context)
                                      .closedOccasionsList
                                      .length,
                                  itemBuilder: (context, index) {
                                    final occasionItem =
                                        OccasionsListCubit.get(context)
                                            .closedOccasionsList[index];
                                    return OccasionCard(
                                        onTap: () {
                                          customPushNavigator(
                                              context,
                                              OccasionDetails(
                                                occasionId: occasionItem.occasionId,
                                              ));
                                        },
                                        forOthers: true,
                                        occasionName: occasionItem.occasionName,
                                        personName: occasionItem.personName,
                                        imageUrl: occasionItem.occasionImage,);
                                  },
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(AssetsManager.noData),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('noOccasions')
                                          .toString(),
                                      style: TextStyles.textStyle18Bold
                                          .copyWith(
                                              color: ColorManager.primaryBlue),
                                    ),
                                  ],
                                ),
                              ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
