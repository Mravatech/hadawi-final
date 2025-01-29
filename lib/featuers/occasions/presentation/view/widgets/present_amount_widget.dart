import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

import '../../../../../utiles/localiztion/app_localization.dart';

class PresentAmountWidget extends StatefulWidget {
  const PresentAmountWidget({super.key});

  @override
  _PresentAmountWidgetState createState() => _PresentAmountWidgetState();
}

class _PresentAmountWidgetState extends State<PresentAmountWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OccasionCubit, OccasionState>(
      builder: (context, state) {
        final cubit = context.read<OccasionCubit>();
        return Row(
          children: [
            Container(
              width:  MediaQuery.sizeOf(context).width*0.4,
              decoration: BoxDecoration(
                color: ColorManager.gray,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all( 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        cubit.giftPrice++;
                      });
                    },
                    child: Icon(
                      Icons.arrow_drop_up,
                      size:  MediaQuery.sizeOf(context).width*0.075,
                      color: ColorManager.primaryBlue,
                    ),
                  ),
                   Text(
                    cubit.giftPrice.toString(),
                    style: TextStyles.textStyle18Bold,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (cubit.giftPrice == 0) {
                          return;
                        }else{
                          cubit.giftPrice--;
                        }
                      });
                    },
                    child: Icon(
                      Icons.arrow_drop_down,
                      size:  MediaQuery.sizeOf(context).width*0.075,

                      color: ColorManager.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            Text(
              AppLocalizations.of(context)!.translate('rsa').toString(),

              style: TextStyles.textStyle18Regular,
            ),

          ],
        );
      },
    );
  }
}
