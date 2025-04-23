import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/closed_occasions.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/my_occasions.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/others_occasions.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/past_occasions.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/profile_row_widget.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/row_data_widget.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';

class AllOccasionsViewBody extends StatelessWidget {
  const AllOccasionsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.07,
          ),

          // المناسبات المسحله جديثا
          InkWell(
              onTap: () => customPushNavigator(context, MyOccasions()),
              child: ProfileRowWidget(
                image: '',
                title: AppLocalizations.of(context)!
                    .translate('newEvents')
                    .toString(),
              )),

          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.045,
          ),

          // المناسبات المسحله لاخر
          InkWell(
            onTap: () => customPushNavigator(context, OthersOccasions()),
            child: ProfileRowWidget(
              image: '',
              title: AppLocalizations.of(context)!
                  .translate('lastEvents')
                  .toString(),
            ),
          ),

          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.045,
          ),

          // المناسبات المسحله سابقا
          InkWell(
              onTap: () => customPushNavigator(context, PastOccasions()),
              child: ProfileRowWidget(
                image: '',
                title: AppLocalizations.of(context)!
                    .translate('previousEvents')
                    .toString(),
              )),

          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.045,
          ),

          // المناسبات المغلقه
          InkWell(
              onTap: () => customPushNavigator(context, ClosedOccasions()),
              child: ProfileRowWidget(
                image: '',
                title: AppLocalizations.of(context)!
                    .translate('closedEvents')
                    .toString(),
              )),
        ],
      ),
    );
  }
}
