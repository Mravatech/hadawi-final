import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_states.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/occasion_qr.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PrivacyPoliciesScreen extends StatefulWidget {
  const PrivacyPoliciesScreen({super.key,});

  @override
  State<PrivacyPoliciesScreen> createState() => _PrivacyPoliciesScreenState();
}

class _PrivacyPoliciesScreenState extends State<PrivacyPoliciesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        final mediaQuery = MediaQuery.sizeOf(context);
        return ModalProgressHUD(
          inAsyncCall: state is GetUserNotificationsLoadingState ? true : false,
          child: Scaffold(
            backgroundColor: ColorManager.white,
            appBar: AppBar(
                backgroundColor: ColorManager.gray,
                leading: IconButton(
                    onPressed: (){
                      setState(() {
                        cubit.currentIndex=3;
                      });
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back)),
                title: Text(
                  AppLocalizations.of(context)!.translate('privacyPolicies').toString(),
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
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(mediaQuery.width * 0.03),
                child: Column(
                  children: [
                    Text(cubit.privacyPolicies,style: TextStyles.textStyle18Medium.copyWith(color: ColorManager.primaryBlue),),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
