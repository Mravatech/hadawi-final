import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_cubit.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_states.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/widgets/occasions_card.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/widgets/default_button_with_image.dart';

class MyOccasions extends StatefulWidget {
  const MyOccasions({super.key});

  @override
  State<MyOccasions> createState() => _MyOccasionsState();
}

class _MyOccasionsState extends State<MyOccasions> {
  @override
  void initState() {
    // TODO: implement initState
    OccasionsListCubit.get(context).getMyOccasionsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.gray,
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "قائمة مناسباتى المسجلة حديثا",
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
              DefaultButtonWithImage(
                buttonText: "مشاركة القائمة",
                image: AssetsManager.shareIcon,
                onTap: () {},
              ),
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
                                        onTap: () {},
                                        forOthers: false,
                                        occasionName: occasionItem.occasionName,
                                        personName: "",
                                        imageUrl: occasionItem.occasionImage,
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
                                        "لا يوجد مناسبات سجلة حديثا",
                                        style: TextStyles.textStyle18Bold
                                            .copyWith(
                                                color:
                                                    ColorManager.primaryBlue),
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
      ),
    );
  }
}
