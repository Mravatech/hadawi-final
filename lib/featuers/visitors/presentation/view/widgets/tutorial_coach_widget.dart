import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/widgets/default_button.dart';

class TutorialCoachWidget extends StatefulWidget {
  const TutorialCoachWidget(
      {super.key,
        required this.text,
        required this.onNext,
        required this.onSkip});
  final String text;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  State<TutorialCoachWidget> createState() => _TutorialCoachWidgetState();
}

class _TutorialCoachWidgetState extends State<TutorialCoachWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ), // BoxDecoration

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              widget.text,
              style: TextStyles.textStyle12Medium.copyWith(
                  color: ColorManager.black
              )
          ), // Text

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onSkip,
                child: Text(
                    AppLocalizations.of(context)!.translate('skip').toString(),
                    style: TextStyles.textStyle12Medium.copyWith(
                        color: ColorManager.primaryBlue
                    )
                ),
              ), // TextButton

              const SizedBox(width: 16),

              TextButton(
                onPressed: widget.onNext,
                child: Text(
                    AppLocalizations.of(context)!.translate('next').toString(),
                    style: TextStyles.textStyle12Medium.copyWith(
                        color: ColorManager.primaryBlue
                    )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}