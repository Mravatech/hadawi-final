import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/data/models/complete_occasion_model.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/widgets/progress_indicator_widget.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ActiveOccasionCard extends StatelessWidget {
  final OccasionEntity occasionEntity;

  const ActiveOccasionCard({super.key, required this.occasionEntity});

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
            mainAxisAlignment: MainAxisAlignment.start,
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
                    occasionEntity.type.toString(),
                    style: TextStyles.textStyle18Regular
                        .copyWith(color: ColorManager.white),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 10.0,
                animation: true,
                percent: occasionEntity.moneyGiftAmount==0?0.0: double.parse((occasionEntity.moneyGiftAmount.toString()))/double.parse((occasionEntity.giftPrice.toString())),
                center:  Text(
                  "${((occasionEntity.moneyGiftAmount==0?0.0: double.parse((occasionEntity.moneyGiftAmount.toString()))/double.parse((occasionEntity.giftPrice.toString())))*100).toStringAsFixed(2)}%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: ColorManager.primaryBlue,
              ),
            ],
          ),
        );
      },
    );
  }
}
