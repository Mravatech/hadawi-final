import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class OccasionCard extends StatelessWidget {
  final OccasionEntity occasionEntity;

  const OccasionCard({super.key, required this.occasionEntity});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitorsCubit, VisitorsState>(
      builder: (context, state) {
        final cubit = context.read<VisitorsCubit>();
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.25,
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
               Container(
                height: MediaQuery.sizeOf(context).height * 0.06,
                decoration: BoxDecoration(
                  color: ColorManager.primaryBlue,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    occasionEntity.occasionName.toString(),
                    style: TextStyles.textStyle18Regular
                        .copyWith(color: ColorManager.white),
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    width: occasionEntity.giftImage.isEmpty
                        ? MediaQuery.sizeOf(context).width * 0.25
                        : double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: occasionEntity.giftImage,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) {
                      return occasionEntity.giftImage.isEmpty &&
                              occasionEntity.giftType == 'مبلغ مالي'
                          ? Image.asset(
                            'assets/images/money_bag.png',
                            fit: BoxFit.contain,
                          )
                          : const Icon(
                              Icons.error,
                              color: Colors.red,
                            );
                    },
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
