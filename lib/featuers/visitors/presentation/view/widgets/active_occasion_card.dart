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
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ActiveOccasionCard extends StatelessWidget {
  final OccasionEntity occasionEntity;

  const ActiveOccasionCard({super.key, required this.occasionEntity});

  int _getDaysLeft() {
    final occasionDate = DateTime.parse(occasionEntity.occasionDate);
    final now = DateTime.now();
    final difference = occasionDate.difference(now);
    return difference.inDays + 1; // +1 to include today
  }

  @override
  Widget build(BuildContext context) {
    final double progress = occasionEntity.moneyGiftAmount == 0 
      ? 0.0 
      : double.parse(occasionEntity.moneyGiftAmount.toString()) / double.parse(occasionEntity.giftPrice.toString());
    
    final daysLeft = _getDaysLeft();
    
    return BlocBuilder<VisitorsCubit, VisitorsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF8B7BA8), // Purple background color
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with gift icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    occasionEntity.type,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.card_giftcard,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              // Subtitle
              Text(
                "${AppLocalizations.of(context)!.translate('for').toString()} ${occasionEntity.personName}'s ${occasionEntity.occasionName}",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16),
              // Goal and Collected amounts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('goal').toString(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.translate('rsa').toString()} ${occasionEntity.giftPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('collected').toString(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.translate('rsa').toString()} ${occasionEntity.moneyGiftAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Progress bar
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                lineHeight: 8.0,
                percent: occasionEntity.moneyGiftAmount/occasionEntity.giftPrice,
                backgroundColor: Colors.white.withOpacity(0.2),
                progressColor: Colors.white,
                barRadius: Radius.circular(4),
                animation: true,
              ),
              SizedBox(height: 12),
              // Bottom row with contributors and days left
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${(occasionEntity.giftPrice/double.parse(occasionEntity.amountForEveryone)).toStringAsFixed(0)} ${AppLocalizations.of(context)!.translate('contributors').toString()}", // Hardcoded for now
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Text(
                        daysLeft < 1 
                          ? AppLocalizations.of(context)!.translate('expired').toString()
                          : "$daysLeft ${AppLocalizations.of(context)!.translate('daysLeft').toString()}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
