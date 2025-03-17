import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_cubit.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_states.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: SizeConfig.height * 0.05,
          width: SizeConfig.height * 0.2,
          decoration: BoxDecoration(
            color: ColorManager.gray,
            borderRadius:
            BorderRadius.circular(SizeConfig.height * 0.01),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.remove,
                  color: ColorManager.primaryBlue,
                ),
              ),

              BlocBuilder<PaymentCubit, PaymentStates>(
                builder: (context, state) {
                  return Text(
                    PaymentCubit.get(context).paymentAmountController.text,
                    style: TextStyles.textStyle18Medium.copyWith(
                      color: ColorManager.primaryBlue,
                    ),
                  );
                },
              ),

              IconButton(
                onPressed: (){},
                icon: Icon(
                  Icons.add,
                  color: ColorManager.primaryBlue,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: SizeConfig.width * 0.02,
        ),
        Text(
          "ريال",
          style: TextStyles.textStyle18Bold.copyWith(
            color: ColorManager.black,
          ),
        ),
      ],
    );
  }
}
