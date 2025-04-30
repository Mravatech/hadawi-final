import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
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
import 'package:hadawi_app/utiles/router/app_router.dart';

class MyGiftsWidget extends StatefulWidget {
  const MyGiftsWidget({super.key});

  @override
  State<MyGiftsWidget> createState() => _MyGiftsWidgetState();
}

class _MyGiftsWidgetState extends State<MyGiftsWidget> {
  @override
  void initState() {
    OccasionsListCubit.get(context).getMyOccasionsList();
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
            AppLocalizations.of(context)!.translate("myGifts").toString(),
            style: TextStyles.textStyle18Bold
                .copyWith(color: ColorManager.primaryBlue),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              context.replace(AppRouter.home);
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child:
              Image(image: AssetImage(AssetsManager.logoWithoutBackground)),
            ),
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
                return state is GetMyOccasionListLoadingState
                    ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                    : Expanded(
                  child: state is GetMyOccasionListSuccessState &&
                      OccasionsListCubit.get(context)
                          .myOccasionsList
                          .isNotEmpty
                      ? RefreshIndicator(
                    onRefresh: () async {
                      await OccasionsListCubit.get(context)
                          .getMyOccasionsList();
                    },
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.96,
                      ),
                      itemCount: OccasionsListCubit.get(context)
                          .myOccasionsList
                          .length,
                      itemBuilder: (context, index) {
                        final occasionItem =
                        OccasionsListCubit.get(context)
                            .myOccasionsList[index];
                        return OccasionCard(
                          onTap: () {
                            customPushNavigator(
                                context,
                                OccasionDetails(
                                  occasionId:
                                  occasionItem.occasionId,
                                  fromHome: false,
                                ));
                          },
                          forOthers: false,
                          occasionName: occasionItem.occasionName,
                          personName: "",
                          imageUrl: occasionItem.occasionImage[index],
                        );
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
