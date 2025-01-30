import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/all_occasions/presentation/view/widgets/all_occasions_view_body.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/widgets/default_app_bar_widget.dart';
import 'package:hadawi_app/widgets/main_app_bar_widget.dart';

class AllOccasionsScreen extends StatelessWidget {
  const AllOccasionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: mainAppBarWidget(appBarTitle: AppLocalizations.of(context)!.translate('occasionsList').toString() ),
      body: AllOccasionsViewBody(),
    );
  }
}
