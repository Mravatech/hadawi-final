import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/data/models/occasion_model.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_cubit.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_states.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:intl/intl.dart';

class MyGiftPaymentsList extends StatefulWidget {
  final String occasionId;
  const MyGiftPaymentsList({super.key, required this.occasionId});

  @override
  State<MyGiftPaymentsList> createState() => _MyGiftPaymentsListState();
}

class _MyGiftPaymentsListState extends State<MyGiftPaymentsList> {
  @override
  void initState() {
    // TODO: implement initState
    PaymentCubit.get(context)
        .getOccasionPaymentsList(occasionId: widget.occasionId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.gray,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            AppLocalizations.of(context)!.translate("myOccasionPaymentList").toString(),
            style: TextStyles.textStyle18Medium
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
      body: BlocBuilder<PaymentCubit, PaymentStates>(
        builder: (context, state) {
          return SingleChildScrollView(
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
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.height * 0.01),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("date")
                                    .toString(),
                                style: TextStyles.textStyle10Bold
                                    .copyWith(color: ColorManager.white),
                                textAlign: TextAlign.center,
                              )),
                          Expanded(
                            flex: 2,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate("name")
                                  .toString(),
                              style: TextStyles.textStyle10Bold
                                  .copyWith(color: ColorManager.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate("amount")
                                  .toString(),
                              style: TextStyles.textStyle10Bold
                                  .copyWith(color: ColorManager.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate("occasions")
                                  .toString(),
                              style: TextStyles.textStyle10Bold
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
                    padding: EdgeInsets.only(top: SizeConfig.height * 0.01),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.height * 0.01,
                            vertical: SizeConfig.height * 0.005),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(
                                    DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(PaymentCubit.get(context)
                                        .occasionPaymentsList[index]
                                        .paymentDate)).toString(),
                                  style: TextStyles.textStyle10Bold.copyWith(
                                      color: ColorManager.primaryBlue),
                                  textAlign: TextAlign.center,
                                )),
                            Expanded(
                              flex: 2,
                              child: Text(
                                PaymentCubit.get(context)
                                    .occasionPaymentsList[index]
                                    .personName,
                                style: TextStyles.textStyle10Bold
                                    .copyWith(color: ColorManager.primaryBlue),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "${PaymentCubit.get(context).occasionPaymentsList[index].paymentAmount}",
                                style: TextStyles.textStyle10Bold
                                    .copyWith(color: ColorManager.primaryBlue),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                PaymentCubit.get(context)
                                    .occasionPaymentsList[index]
                                    .occasionName,
                                style: TextStyles.textStyle10Bold
                                    .copyWith(color: ColorManager.primaryBlue),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: ColorManager.primaryBlue,
                      );
                    },
                    itemCount:
                        PaymentCubit.get(context).occasionPaymentsList.length,

                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
