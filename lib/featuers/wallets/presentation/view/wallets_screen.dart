import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/all_occasions/presentation/view/widgets/all_occasions_view_body.dart';
import 'package:hadawi_app/featuers/settings/presentation/view/widgets/settings_view_body.dart';
import 'package:hadawi_app/featuers/wallets/presentation/view/widgets/wallets_view_body.dart';
import 'package:hadawi_app/widgets/default_app_bar_widget.dart';

class WalletsScreen extends StatelessWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBarWidget(appBarTitle: 'البروفيل - المحفظه',context: context),
      body: WalletsViewBody(),
    );
  }
}
