import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/widgets/counter_widget.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/widgets/progress_indicator_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_button_with_image.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';

class PaymentGiftScreen extends StatelessWidget {
  final OccasionEntity occasionEntity;
  const PaymentGiftScreen({super.key, required this.occasionEntity});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
            backgroundColor: ColorManager.gray,
            title: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "${AppLocalizations.of(context)!.translate("payment").toString()} ${occasionEntity.occasionType} (${occasionEntity.personName})",
                style: TextStyles.textStyle18Bold
                    .copyWith(color: ColorManager.primaryBlue),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image(
                    image: AssetImage(AssetsManager.logoWithoutBackground)),
              ),
            ]),
        body: Padding(
          padding: EdgeInsets.all(SizeConfig.height * 0.02),
          child: Column(
            children: [
              /// payment progress
              SizedBox(height: SizeConfig.height * 0.02),

              ProgressIndicatorWidget(
                value: 0.6,
              ),

              SizedBox(height: SizeConfig.height * 0.04),

              /// payment amount
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${AppLocalizations.of(context)!.translate("amount").toString()} : ",
                      style: TextStyles.textStyle18Bold.copyWith(
                        color: ColorManager.black,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: CounterWidget(),
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.height * 0.01),

              /// payment name
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${AppLocalizations.of(context)!.translate("phone").toString()} : ",
                      style: TextStyles.textStyle18Bold.copyWith(
                        color: ColorManager.black,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: DefaultTextField(
                      controller: nameController,
                      hintText: '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context)!.translate("phone").toString();
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      fillColor: ColorManager.gray,
                    ),
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.height * 0.08),

              DefaultButton(
                buttonText: AppLocalizations.of(context)!.translate("paymentAsGift").toString(),
                onPressed: () {},
                buttonColor: ColorManager.primaryBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
