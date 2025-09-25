import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/all_occasions/presentation/view/widgets/all_occasions_view_body.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';

class AllOccasionsScreen extends StatefulWidget {
  const AllOccasionsScreen({super.key});

  @override
  State<AllOccasionsScreen> createState() => _AllOccasionsScreenState();
}

class _AllOccasionsScreenState extends State<AllOccasionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
          backgroundColor: ColorManager.white,
          leading: IconButton(
              onPressed: (){
                // Navigate back to Profile screen (index 2 in home layout)
                context.read<HomeCubit>().changeIndex(index: 2);
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back)),
          title: Text(
            AppLocalizations.of(context)!.translate('occasionsList').toString(),
            style: TextStyles.textStyle18Bold.copyWith(
                color: ColorManager.black),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                  image: AssetImage(AssetsManager.logoWithoutBackground)),
            ),
          ]),
      body: AllOccasionsViewBody(),
    );
  }
}
