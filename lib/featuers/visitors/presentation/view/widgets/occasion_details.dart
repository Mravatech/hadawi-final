import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/payment_screen.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/progress_indecator.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/widgets/default_app_bar_widget.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';

class OccasionDetails extends StatelessWidget {
  final OccasionEntity occasionEntity;

  const OccasionDetails({super.key, required this.occasionEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: defaultAppBarWidget(
        appBarTitle: '',
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<VisitorsCubit, VisitorsState>(
          builder: (context, state) {
            final cubit = context.read<VisitorsCubit>();
            return Padding(
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
                    hintText: occasionEntity.occasionName,
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
                    hintText: occasionEntity.occasionDate,
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
                    hintText: occasionEntity.giftName.isEmpty? '${occasionEntity.giftPrice} ريال':occasionEntity.giftName,
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
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.gray.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: occasionEntity.giftImage.isEmpty && occasionEntity.giftType == 'مبلغ مالي'? SizedBox(): CachedNetworkImage(
                      imageUrl: occasionEntity.giftImage,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) {
                        return occasionEntity.giftImage.isEmpty &&
                            occasionEntity.giftType == 'مبلغ مالي' ? Image.asset(
                          'assets/images/money_bag.png',
                          fit: BoxFit.contain,
                        ):const Icon(
                          Icons.error,
                          color: Colors.red,
                        );
                      },
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GiftDetailsProgressIndicatorWidget(
                          value: .6,
                        ),
                      ),
                      IconButton(onPressed: () {
                        cubit.openExerciseLink(occasionEntity.giftLink);
                      }, icon: Icon(Icons.link,
                        color: ColorManager.black,
                        size: MediaQuery.sizeOf(context).height * 0.03,
                      )),

                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  Text(
                    ':المتبقي',
                    style: TextStyles.textStyle18Bold.copyWith(),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
                  DefaultTextField(
                    controller: TextEditingController(),
                    hintText: occasionEntity.moneyGiftAmount,
                    validator: (value) {
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorManager.gray,
                    enable: false,
                  ),
                  SizedBox(
                    height: occasionEntity.giftImage.isEmpty?  MediaQuery.sizeOf(context).height * 0.18:MediaQuery.sizeOf(context).height * 0.04,
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
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width * .05),

                          /// pay
                          GestureDetector(
                            onTap: () =>customPushNavigator(context, PaymentScreen(occasionEntity: occasionEntity,)),
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
            );
          },
        ),
      ),
    );
  }
}
