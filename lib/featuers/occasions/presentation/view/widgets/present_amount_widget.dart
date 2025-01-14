import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

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
            Text(
              'ريال',
              style: TextStyles.textStyle18Regular,
            ),
            const SizedBox(width: 8),
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
                        cubit.giftValue++;
                      });
                    },
                    child: Icon(
                      Icons.arrow_drop_up,
                      size:  MediaQuery.sizeOf(context).width*0.075,
                      color: ColorManager.primaryBlue,
                    ),
                  ),
                   Text(
                    cubit.giftValue.toString(),
                    style: TextStyles.textStyle18Bold,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (cubit.giftValue == 0) {
                          return;
                        }else{
                          cubit.giftValue--;
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
          ],
        );
      },
    );
  }
}
