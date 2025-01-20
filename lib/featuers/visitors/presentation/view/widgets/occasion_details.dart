import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/progress_indecator.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/widgets/default_app_bar_widget.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';

class OccasionDetails extends StatelessWidget {
  const OccasionDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: defaultAppBarWidget(
        appBarTitle: 'أعياد الميلاد',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ':اسم المناسبة',
                style: TextStyles.textStyle18Bold.copyWith(),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.01,
              ),
              DefaultTextField(
                controller: TextEditingController(),
                hintText: 'عيد ميلاد هناء محمد',
                validator: (value) {
                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                fillColor: ColorManager.gray,
                enable: false,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              Text(
                ':تاريخ المناسبة',
                style: TextStyles.textStyle18Bold.copyWith(),
              ),
              DefaultTextField(
                controller: TextEditingController(),
                hintText: 'محمد',
                validator: (value) {
                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                fillColor: ColorManager.gray,
                enable: false,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              Text(
                ':الهدية',
                style: TextStyles.textStyle18Bold.copyWith(),
              ),
              DefaultTextField(
                controller: TextEditingController(),
                hintText: 'جهاز ايفون',
                validator: (value) {
                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                fillColor: ColorManager.gray,
                enable: false,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorManager.gray,
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: MediaQuery.sizeOf(context).height * .055,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: ColorManager.primaryBlue,
                    borderRadius: BorderRadius.circular(
                        MediaQuery.sizeOf(context).height * 0.05),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'الرابط',
                          style: TextStyles.textStyle18Bold
                              .copyWith(color: ColorManager.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              GiftDetailsProgressIndicatorWidget(
                value: .6,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              Text(
                ':المتبقي',
                style: TextStyles.textStyle18Bold.copyWith(),
              ),
              DefaultTextField(
                controller: TextEditingController(),
                hintText: '1500 ريال',
                validator: (value) {
                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                fillColor: ColorManager.gray,
                enable: false,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      /// share
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * .055,
                          width: MediaQuery.sizeOf(context).width * .4,
                          decoration: BoxDecoration(
                            color: ColorManager.primaryBlue,
                            borderRadius: BorderRadius.circular(
                                MediaQuery.sizeOf(context).height * 0.05),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'مشاركة',
                                  style: TextStyles.textStyle18Bold
                                      .copyWith(color: ColorManager.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.sizeOf(context).width * .05),
                      /// pay
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * .055,
                          width: MediaQuery.sizeOf(context).width * .4,
                          decoration: BoxDecoration(
                            color: ColorManager.primaryBlue,
                            borderRadius: BorderRadius.circular(
                                MediaQuery.sizeOf(context).height * 0.05),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ادفع الآن',
                                  style: TextStyles.textStyle18Bold
                                      .copyWith(color: ColorManager.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
