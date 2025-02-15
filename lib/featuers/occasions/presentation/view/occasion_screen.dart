import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/occasion_view_body.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';

class OccasionScreen extends StatelessWidget {
  const OccasionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: OccasionViewBody(),
    );
  }
}
