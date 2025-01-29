import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';

class MyGiftPaymentsList extends StatelessWidget {
  const MyGiftPaymentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.gray,
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "قائمة الاصدقاء الشاركين بهديتى",
              style: TextStyles.textStyle18Bold
                  .copyWith(color: ColorManager.primaryBlue),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(
                Icons.people_outline,
                color: ColorManager.primaryBlue,
                size: SizeConfig.height * 0.04,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(

          child: Padding(
            padding: EdgeInsets.all(SizeConfig.height * 0.01),
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.height * 0.02,
                ),
                Container(
                  height: SizeConfig.height * 0.05,
                  width: SizeConfig.width,
                  color: ColorManager.primaryBlue,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.height*0.01),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.translate("date").toString(),
                              style: TextStyles.textStyle12Bold
                                  .copyWith(color: ColorManager.white),
                              textAlign: TextAlign.center,
                            )),
                        Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("name").toString(),
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            AppLocalizations.of(context)!.translate("amount").toString(),
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("occasions").toString(),
                            style: TextStyles.textStyle12Bold
                                .copyWith(color: ColorManager.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ListView.separated(
                  shrinkWrap: true,
                    padding: EdgeInsets.only(top: SizeConfig.height*0.01),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.height*0.01, vertical: SizeConfig.height*0.005),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(
                                  "15-01-2025",
                                  style: TextStyles.textStyle12Bold
                                      .copyWith(color: ColorManager.primaryBlue),
                                )),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "محمود رضا",
                                style: TextStyles.textStyle12Bold
                                    .copyWith(color: ColorManager.primaryBlue),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "1000",
                                style: TextStyles.textStyle12Bold
                                    .copyWith(color: ColorManager.primaryBlue),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "عيد ميلاد",
                                style: TextStyles.textStyle12Bold
                                    .copyWith(color: ColorManager.primaryBlue),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index){
                      return Divider(color: ColorManager.primaryBlue,);
                    },
                    itemCount: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
