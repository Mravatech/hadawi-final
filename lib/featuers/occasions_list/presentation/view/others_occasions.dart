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

class OthersOccasions extends StatefulWidget {
  const OthersOccasions({super.key});

  @override
  State<OthersOccasions> createState() => _OthersOccasionsState();
}

class _OthersOccasionsState extends State<OthersOccasions> {
  @override
  void initState() {
    // TODO: implement initState
    OccasionsListCubit.get(context).getOthersOccasionsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionsListCubit, OccasionsListStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GetOthersOccasionListLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B7BA8)),
            ),
          );
        }

        final occasions = OccasionsListCubit.get(context).othersOccasionsList;
        
        if (state is GetOthersOccasionListSuccessState && occasions.isNotEmpty) {
          return RefreshIndicator(
            color: Color(0xFF8B7BA8),
            onRefresh: () async {
              await OccasionsListCubit.get(context).getOthersOccasionsList();
            },
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              physics: AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.85,
              ),
              itemCount: occasions.length,
              itemBuilder: (context, index) {
                final occasion = occasions[index];
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
                          OccasionDetails(
                            occasionId: occasion.occasionId,
                            fromHome: false,
                          ),
                        );
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
                                  image: NetworkImage(
                                    occasion.giftType == "مبلغ مالى"
                                        ? "https://firebasestorage.googleapis.com/v0/b/transport-app-d662f.appspot.com/o/logo_without_background.png?alt=media&token=15358a2a-1e34-46c1-be4b-1ea0a1a49eaa"
                                        : occasion.giftImage[0],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    occasion.type,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF8B7BA8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (occasion.personName?.isNotEmpty ?? false) ...[
                                    SizedBox(height: 4),
                                    Text(
                                      occasion.personName!,
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
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetsManager.noData,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.translate('noOccasions').toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B7BA8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
