import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_cubit.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_states.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/my_gift_payments_list.dart';
import 'package:hadawi_app/generated/assets.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';

class MyOccasionsList extends StatefulWidget {
  const MyOccasionsList({super.key});

  @override
  State<MyOccasionsList> createState() => _MyOccasionsListState();
}

class _MyOccasionsListState extends State<MyOccasionsList> {
  @override
  void initState() {
    // TODO: implement initState
    OccasionsListCubit.get(context).getMyOccasionsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: ColorManager.gray,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            AppLocalizations.of(context)!.translate("sharedGifts").toString(),
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
            // DefaultButtonWithImage(
            //   buttonText: "مشاركة القائمة",
            //   image: AssetsManager.shareIcon,
            //   onTap: () {},
            // ),
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
                                    childAspectRatio: 0.85, // Reduced from 0.96 to accommodate more content
                                  ),
                                  itemCount: OccasionsListCubit.get(context)
                                      .myOccasionsList
                                      .length,
                                  itemBuilder: (context, index) {
                                    final occasionItem =
                                        OccasionsListCubit.get(context)
                                            .myOccasionsList[index];
                                    debugPrint("occasionItem ${occasionItem.toJson()}");
                                    debugPrint("occasionName: '${occasionItem.occasionName}'");
                                    debugPrint("occasionType: '${occasionItem.occasionType}'");
                                    debugPrint("type: '${occasionItem.type}'");
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(12),
                                          onTap: () {
                                            customPushNavigator(
                                                context,
                                                MyGiftPaymentsList(
                                                  occasionId:
                                                      occasionItem.occasionId,
                                                  occasionName:
                                                      occasionItem.occasionName,
                                                ));
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                                    image: DecorationImage(
                                                      image: occasionItem.giftType == "مبلغ مالى"
                                                          ? NetworkImage(
                                                              "https://firebasestorage.googleapis.com/v0/b/transport-app-d662f.appspot.com/o/logo_without_background.png?alt=media&token=15358a2a-1e34-46c1-be4b-1ea0a1a49eaa"
                                                            )
                                                          : AssetImage(Assets.imagesLightLogo),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // Extract English and Arabic from type field
                                                      Builder(
                                                        builder: (context) {
                                                          String typeText = occasionItem.type;
                                                          String englishText = '';
                                                          String arabicText = '';
                                                          
                                                          if (typeText.contains(' - ')) {
                                                            // Split by " - " to get Arabic and English parts
                                                            List<String> parts = typeText.split(' - ');
                                                            arabicText = parts[0].trim();
                                                            englishText = parts.length > 1 ? parts[1].trim() : '';
                                                          } else {
                                                            // If no separator, use the whole text for both
                                                            englishText = typeText;
                                                            arabicText = typeText;
                                                          }
                                                          
                                                          return Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              // English occasion name
                                                              if (englishText.isNotEmpty)
                                                                Text(
                                                                  englishText + " - " + arabicText,
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: Color(0xFF8B7BA8),
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              if (englishText.isNotEmpty && arabicText.isNotEmpty)
                                                                SizedBox(height: 1),
                                                              // Arabic occasion name
                                                              // if (arabicText.isNotEmpty)
                                                              //   Text(
                                                              //     arabicText,
                                                              //     style: TextStyle(
                                                              //       fontSize: 12,
                                                              //       fontWeight: FontWeight.w600,
                                                              //       color: Color(0xFF8B7BA8),
                                                              //     ),
                                                              //     maxLines: 1,
                                                              //     overflow: TextOverflow.ellipsis,
                                                              //     textDirection: TextDirection.rtl,
                                                              //   ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                      if (occasionItem.personName.isNotEmpty) ...[
                                                        SizedBox(height: 4),
                                                        Text(
                                                          occasionItem.personName,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey[600],
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
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
