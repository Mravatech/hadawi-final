import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/widgets/present_amount_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';

class GiftScreen extends StatelessWidget {
  const GiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OccasionCubit, OccasionState>(
      builder: (context, state) {
        final cubit = context.read<OccasionCubit>();
        final mediaQuery = MediaQuery.sizeOf(context);
        return Scaffold(
          backgroundColor: ColorManager.white,
          appBar: AppBar(
              backgroundColor: ColorManager.gray,
              leadingWidth:  mediaQuery.width*0.3,
              leading: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: ColorManager.primaryBlue,
                      )),
                  Image(
                      image: AssetImage(AssetsManager.logoWithoutBackground)),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "هدية",
                    style: TextStyles.textStyle18Bold.copyWith(
                        color: ColorManager.black.withValues(
                          alpha: 0.4,
                        )),
                  ),
                )
              ]),
          body: Padding(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// by sharing switch
                  Row(
                    mainAxisAlignment:  MainAxisAlignment.end,
                    children: [
                      Switch(
                          value: cubit.bySharingValue,
                          onChanged: (value) {
                            cubit.switchBySharing();
                          }),

                      Text(
                        ' :مشاركة الهدية',
                        style: TextStyles.textStyle18Bold
                            .copyWith(color: ColorManager.black),
                      ),
                    ],
                  ),
                  SizedBox(height: mediaQuery.height * 0.03),

                  /// gift name
                  Column(
                    crossAxisAlignment:  CrossAxisAlignment.end,
                    children: [
                      Text(
                        ' :اسم الهدية',
                        style: TextStyles.textStyle18Bold
                            .copyWith(color: ColorManager.black),
                      ),
                      DefaultTextField(
                          controller: cubit.giftNameController,
                          hintText: '',
                          validator: (value) {
                            return '';
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          fillColor: ColorManager.gray),


                    ],
                  ),
                  SizedBox(height: mediaQuery.height * 0.04),
                  /// link
                  Column(
                    crossAxisAlignment:  CrossAxisAlignment.end,

                    children: [
                      Text(
                        ' :رابطها ',
                        style: TextStyles.textStyle18Bold
                            .copyWith(color: ColorManager.black),
                      ),
                      DefaultTextField(
                          controller: cubit.linkController,
                          hintText: '',
                          validator: (value) {
                            return '';
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          fillColor: ColorManager.gray),
                    ],
                  ),

                  SizedBox(height: mediaQuery.height * 0.04),
                  /// picture
                  Row(
                    mainAxisAlignment:  MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.file_upload_outlined,
                            size:  mediaQuery.height * 0.04,
                            color: ColorManager.primaryBlue,
                          )),
                      Container(
                        height: mediaQuery.height * 0.2,
                        width: mediaQuery.width * 0.5,
                        decoration: BoxDecoration(
                            color: ColorManager.gray,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      Text(
                        ' :صورتها ',
                        style: TextStyles.textStyle18Bold
                            .copyWith(color: ColorManager.black),
                      ),
                    ],
                  ),
                  SizedBox(height: mediaQuery.height * 0.04),
                  /// amount
                  Row(
                    mainAxisAlignment:  MainAxisAlignment.end,
                    children: [
                      PresentAmountWidget() ,
                      Text(
                        ' :قيمتها',
                        style: TextStyles.textStyle18Bold
                            .copyWith(color: ColorManager.black),
                      ),],
                  ),
                  SizedBox(height: mediaQuery.height * 0.12),
                  /// add another and save
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// share button
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: mediaQuery.height * .055,
                          width: mediaQuery.width * .4,
                          decoration: BoxDecoration(
                            color:  ColorManager.primaryBlue,
                            borderRadius:
                            BorderRadius.circular(mediaQuery.height * 0.05),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'اضافة اخرى',
                                  style: TextStyles.textStyle18Bold.copyWith(
                                      color: ColorManager.white
                                          ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// save button
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          height: mediaQuery.height * .055,
                          width: mediaQuery.width * .4,
                          decoration: BoxDecoration(
                            color: ColorManager.primaryBlue
                                ,
                            borderRadius:
                            BorderRadius.circular(mediaQuery.height * 0.05),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'حفظ',
                                  style: TextStyles.textStyle18Bold.copyWith(
                                      color:  ColorManager.white
                                          ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )



                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
