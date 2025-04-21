import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/data/models/complete_occasion_model.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class OccasionCard extends StatelessWidget {
  final CompleteOccasionModel occasionEntity;
   bool isOrders=false;

   OccasionCard({super.key, required this.occasionEntity, this.isOrders=false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitorsCubit, VisitorsState>(
      builder: (context, state) {
        final cubit = context.read<VisitorsCubit>();
        return Container(
          height: isOrders?MediaQuery.sizeOf(context).height * 0.35: MediaQuery.sizeOf(context).height * 0.25,
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
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: occasionEntity.imagesUrl,
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
                      Positioned(
                        top: 10,
                        left: 0,
                        child:Container(
                          alignment:  Alignment.center,
                          height:  MediaQuery.sizeOf(context).height * 0.04,
                          width: MediaQuery.sizeOf(context).height * 0.06 ,
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
                                fontSize: 13
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              if(isOrders)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.01,
                    ),
                    Text(occasionEntity.status.toString(),
                      style: TextStyles.textStyle18Regular.copyWith(
                          color: ColorManager.primaryBlue
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.01,
                    ),
                  ],
                ),

              Container(
                alignment:Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                height: MediaQuery.sizeOf(context).height * 0.1,
                decoration: BoxDecoration(
                  borderRadius:  BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: ColorManager.primaryBlue,
                ),
                child: Text(occasionEntity.title.toString(),
                  style: TextStyles.textStyle18Regular.copyWith(
                      color: ColorManager.white
                  ),
                  textAlign:  TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
