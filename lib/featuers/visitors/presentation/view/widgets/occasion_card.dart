import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/data/models/complete_occasion_model.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/open_image.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';

class OccasionCard extends StatelessWidget {
  final CompleteOccasionModel occasionEntity;
   bool isOrders=true;

   OccasionCard({super.key, required this.occasionEntity, this.isOrders=true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitorsCubit, VisitorsState>(
      builder: (context, state) {
        final cubit = context.read<VisitorsCubit>();
        return Container(
          height: isOrders?MediaQuery.sizeOf(context).height * 0.4: MediaQuery.sizeOf(context).height * 0.35,
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: ColorManager.gray.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
               Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      PageView(
                        children: List.generate(occasionEntity.imagesUrl2!=''?2:1, (index) {
                          return GestureDetector(
                            onTap: (){
                              customPushNavigator(context, ImageViewerScreen(
                                  imageUrl: index==0? occasionEntity.imagesUrl:
                                  occasionEntity.imagesUrl2));
                            },
                            child: CachedNetworkImage(
                              width: double.infinity,
                              fit: BoxFit.fill,
                              imageUrl: index==0? occasionEntity.imagesUrl: occasionEntity.imagesUrl2,
                              placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator(),
                              ),
                              errorWidget: (context, url, error) {
                                return const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                );
                              },
                            ),
                          );
                        }),
                      ),
                      Positioned(
                        top: 10,
                        left: 0,
                        child:Container(
                          alignment:  Alignment.center,
                          height:  MediaQuery.sizeOf(context).height * 0.04,
                          width: MediaQuery.sizeOf(context).height * 0.1 ,
                          padding:  const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.red,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(7),
                              topRight: Radius.circular(7),
                            ),
                          ),
                          child: Text(
                            occasionEntity.finalPrice.toString(),
                            overflow:  TextOverflow.ellipsis,
                            style: TextStyles.textStyle18Bold.copyWith(
                                color: ColorManager.white,
                                fontSize: 12
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              Container(
                alignment:Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                decoration: BoxDecoration(
                  borderRadius:  BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Expanded(
                  child: Column(
                    children: [
                      Text(occasionEntity.title.toString(),
                        style: TextStyles.textStyle18Bold.copyWith(
                            color: ColorManager.primaryBlue
                        ),
                        textAlign:  TextAlign.center,
                      ),
                      Text(occasionEntity.des.toString(),
                        style: TextStyles.textStyle18Regular.copyWith(
                            color: ColorManager.primaryBlue,
                            fontSize: 10
                        ),
                        textAlign:  TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
