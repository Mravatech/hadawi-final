import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_states.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_details.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_card.dart';

class MyOrdersWidgets extends StatefulWidget {
  const MyOrdersWidgets({super.key});

  @override
  State<MyOrdersWidgets> createState() => _MyOrdersWidgetsState();
}

class _MyOrdersWidgetsState extends State<MyOrdersWidgets> {
  @override
  void initState() {
    context.read<VisitorsCubit>().getOccasions();
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
            AppLocalizations.of(context)!.translate("myRequests").toString(),
            style: TextStyles.textStyle18Bold
                .copyWith(color: ColorManager.primaryBlue),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              customPushReplacement(context, HomeLayout());
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
        child: BlocConsumer<VisitorsCubit, VisitorsState>(
              listener: (context, state) {},
              builder: (context, state) {
                var cubit = context.read<VisitorsCubit>();
                return cubit.myOrderOccasions.isEmpty?
                Center(
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
                 ) :  GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(15),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.1),
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                        },
                        child: OccasionCard(
                          occasionEntity: cubit.myOrderOccasions[index],
                          isOrders: true,
                        ));
                  },
                  itemCount: cubit.myOrderOccasions.length,
                );
              },
            ),
      ),
    );
  }
}
