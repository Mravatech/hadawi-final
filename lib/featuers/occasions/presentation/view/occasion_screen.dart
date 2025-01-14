import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/occasion_view_body.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class OccasionScreen extends StatelessWidget {
  const OccasionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OccasionCubit>(
      create: (context) => OccasionCubit(),
      child: Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
            backgroundColor: ColorManager.gray,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Image(
                  image: AssetImage(AssetsManager.logoWithoutBackground)),
            ),
            actions: [Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "اضافة مناسبة", style: TextStyles.textStyle18Bold.copyWith(
                  color: ColorManager.black.withValues(alpha: 0.4,)
              ),),
            )]
        ),
        body: OccasionViewBody(),
      ),
    );
  }
}
