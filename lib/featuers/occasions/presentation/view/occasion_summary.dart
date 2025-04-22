import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/loading_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class OccasionSummary extends StatelessWidget {
  OccasionSummary({super.key});

  final GlobalKey<FormState> discountCardKey = GlobalKey<FormState>();
  // Cached logo image provider to prevent repeated loading
  final ImageProvider _logoProvider = AssetImage(AssetsManager.logoWithoutBackground);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionCubit, OccasionState>(
      listener: (context, state) {
        if (state is AddOccasionSuccessState) {
          context.read<OccasionCubit>().resetData();
          customPushNavigator(
            context,
            OccasionQr(
              occasionId: state.occasion.occasionId,
              occasionName: state.occasion.occasionName,
            ),
          );
        } else if (state is AddOccasionErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<OccasionCubit>();
        final mediaQuery = MediaQuery.sizeOf(context);
        final isRTL = CashHelper.languageKey == 'ar';

        return Scaffold(
          backgroundColor: ColorManager.white,
          appBar: AppBar(
            backgroundColor: ColorManager.gray,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: ColorManager.black),
            ),
            title: Text(
              AppLocalizations.of(context)!.translate('occasionSummary').toString(),
              style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => context.replace(AppRouter.home),
                  child: Image(image: _logoProvider, height: 40),
                ),
              ),
            ],
          ),
          body: ModalProgressHUD(
            inAsyncCall: state is AddOccasionLoadingState || state is UploadImageLoadingState,
            progressIndicator: LoadingAnimationWidget(),
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        // Main occasion details card
                        _buildSectionCard(
                          context,
                          title: AppLocalizations.of(context)!.translate('occasionDetails').toString(),
                          children: [
                            _buildInfoRow(
                              context,
                              label: AppLocalizations.of(context)!.translate('occasionName').toString(),
                              value: cubit.occasionNameController.text,
                            ),
                            _buildInfoRow(
                              context,
                              label: AppLocalizations.of(context)!.translate('occasionType').toString(),
                              value: cubit.dropdownOccasionType,
                            ),
                            if (cubit.isForMe == false)
                              _buildInfoRow(
                                context,
                                label: AppLocalizations.of(context)!.translate('personName').toString(),
                                value: cubit.nameController.text,
                              ),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Gift details card
                        if (cubit.isPresent == true)
                          _buildSectionCard(
                            context,
                            title: AppLocalizations.of(context)!.translate('giftDetails').toString(),
                            children: [
                              _buildInfoRow(
                                context,
                                label: AppLocalizations.of(context)!.translate('giftName').toString(),
                                value: cubit.giftNameController.text,
                              ),
                              if (cubit.linkController.text.isNotEmpty)
                                _buildInfoRow(
                                  context,
                                  label: AppLocalizations.of(context)!.translate('link').toString(),
                                  value: cubit.linkController.text,
                                  isLink: true,
                                ),
                              if (cubit.image != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Column(
                                    crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${AppLocalizations.of(context)!.translate('gifPicture').toString()}:",
                                        style: TextStyles.textStyle12Bold.copyWith(color: ColorManager.black),
                                      ),
                                      SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          cubit.image!,
                                          fit: BoxFit.cover,
                                          height: mediaQuery.height * 0.2,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),

                        if (cubit.isPresent == true) SizedBox(height: 16),

                        // Financial details card
                        _buildSectionCard(
                          context,
                          title: AppLocalizations.of(context)!.translate('financialDetails').toString(),
                          children: [
                            _buildInfoRow(
                              context,
                              label: AppLocalizations.of(context)!.translate('giftAmount').toString(),
                              value: "${cubit.moneyAmountController.text} ${AppLocalizations.of(context)!.translate('rsa').toString()}",
                            ),
                            _buildInfoRow(
                              context,
                              label: AppLocalizations.of(context)!.translate('packaging').toString(),
                              value: cubit.giftWithPackage
                                  ? AppLocalizations.of(context)!.translate('withPackaging').toString()
                                  : AppLocalizations.of(context)!.translate('withoutPackaging').toString(),
                            ),

                            if (cubit.giftWithPackage)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: _buildInfoRow(
                                        context,
                                        label: AppLocalizations.of(context)!.translate('packagingPrice').toString(),
                                        value: "${cubit.giftWithPackageType} ${AppLocalizations.of(context)!.translate('rsa').toString()}",
                                      ),
                                    ),
                                    if (cubit.selectedPackageImage.isNotEmpty)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: ColorManager.gray,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            cubit.selectedPackageImage,
                                            fit: BoxFit.cover,
                                            height: 40,
                                            width: 40,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Container(
                                                height: 40,
                                                width: 40,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                        : null,
                                                    strokeWidth: 2,
                                                    color: ColorManager.primaryBlue,
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                height: 40,
                                                width: 40,
                                                color: ColorManager.gray,
                                                child: Icon(Icons.image_not_supported, color: Colors.grey),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                            if (cubit.isPresent == false && cubit.giftWithPackage == false) ...[
                              _buildInfoRow(
                                context,
                                label: AppLocalizations.of(context)!.translate('moneyReceiverName').toString(),
                                value: cubit.giftReceiverNameController.text,
                              ),
                              _buildInfoRow(
                                context,
                                label: AppLocalizations.of(context)!.translate('bankName').toString(),
                                value: cubit.bankNameController.text,
                              ),
                              _buildInfoRow(
                                context,
                                label: AppLocalizations.of(context)!.translate('ibanNumber').toString(),
                                value: cubit.ibanNumberController.text,
                              ),
                            ],
                          ],
                        ),

                        SizedBox(height: 16),

                        // Delivery details card
                        if (cubit.isPresent == true || (cubit.isPresent == false && cubit.giftWithPackage == true))
                          _buildSectionCard(
                            context,
                            title: AppLocalizations.of(context)!.translate('deliveryDetails').toString(),
                            children: [
                              _buildInfoRow(
                                context,
                                label: AppLocalizations.of(context)!.translate('City').toString(),
                                value: cubit.dropdownCity,
                              ),
                              _buildInfoRow(
                                context,
                                label: AppLocalizations.of(context)!.translate('theDistrict').toString(),
                                value: cubit.giftDeliveryStreetController.text,
                              ),
                              _buildInfoRow(
                                context,
                                label: AppLocalizations.of(context)!.translate('moneyReceiverPhone').toString(),
                                value: cubit.giftReceiverNumberController.text,
                              ),
                              if (cubit.giftDeliveryNoteController.text.isNotEmpty)
                                _buildInfoRow(
                                  context,
                                  label: AppLocalizations.of(context)!.translate('note').toString(),
                                  value: cubit.giftDeliveryNoteController.text,
                                  isMultiLine: true,
                                ),
                            ],
                          ),

                        if (cubit.isPresent == true || (cubit.isPresent == false && cubit.giftWithPackage == true))
                          SizedBox(height: 16),

                        // Gift message card
                        _buildSectionCard(
                          context,
                          title: AppLocalizations.of(context)!.translate('giftCard').toString(),
                          children: [
                            _buildInfoRow(
                              context,
                              label: AppLocalizations.of(context)!.translate('giftCard').toString(),
                              value: cubit.moneyGiftMessageController.text,
                              isMultiLine: true,
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: ColorManager.gray.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    cubit.giftContainsNameValue ? Icons.check_circle : Icons.cancel,
                                    color: cubit.giftContainsNameValue ? Colors.green : Colors.red,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      cubit.giftContainsNameValue
                                          ? AppLocalizations.of(context)!.translate('containsNames').toString()
                                          : AppLocalizations.of(context)!.translate('noContainsNames').toString(),
                                      style: TextStyles.textStyle12Bold.copyWith(
                                        color: cubit.giftContainsNameValue ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Pricing details card
                        _buildSectionCard(
                          context,
                          title: AppLocalizations.of(context)!.translate('pricing').toString(),
                          children: [
                            if (cubit.isPresent == false && cubit.giftWithPackage != false)
                              _buildInfoRow(
                                context,
                                label: AppLocalizations.of(context)!.translate('deliveryPrice').toString(),
                                value: "${cubit.deliveryTax} ${AppLocalizations.of(context)!.translate('rsa')}",
                                subtitle: "المطلوب مبلغ مالي بدون تغليف وسيتم التحويل البنكي",
                              ),

                            if (cubit.showDiscountValue)
                              _buildInfoRow(
                                context,
                                label: AppLocalizations.of(context)!.translate('discountAmount').toString(),
                                value: "${cubit.discountValue} ${AppLocalizations.of(context)!.translate('rsa')}",
                                valueColor: Colors.green,
                              ),

                            _buildInfoRow(
                              context,
                              label: AppLocalizations.of(context)!.translate('totalAmount').toString(),
                              value: "${context.read<OccasionCubit>().giftPrice} ${AppLocalizations.of(context)!.translate('rsa')}",
                              valueColor: ColorManager.primaryBlue,
                              isTotal: true,
                            ),
                          ],
                        ),

                        // Discount code section
                        if (cubit.showDiscountField)
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                            child: Form(
                              key: discountCardKey,
                              child: Column(
                                crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.translate('addDiscountCardMessage').toString(),
                                    style: TextStyles.textStyle12Bold.copyWith(color: ColorManager.black),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: DefaultTextField(
                                          controller: cubit.discountCodeController,
                                          hintText: AppLocalizations.of(context)!.translate('discountCardHint').toString(),
                                          validator: (value) {
                                            if (value!.trim().isEmpty) {
                                              return AppLocalizations.of(context)!.translate('validateDiscountCard').toString();
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                          fillColor: ColorManager.gray,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      ElevatedButton(
                                        onPressed: state is GetOccasionDiscountLoadingState
                                            ? null
                                            : () {
                                          if (discountCardKey.currentState!.validate()) {
                                            cubit.getDiscountCode();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorManager.primaryBlue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          minimumSize: Size(100, 48),
                                        ),
                                        child: state is GetOccasionDiscountLoadingState
                                            ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                            : Text(
                                          AppLocalizations.of(context)!.translate('apply').toString(),
                                          style: TextStyles.textStyle12Bold.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                        SizedBox(height: 32),

                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: state is AddOccasionLoadingState
                                    ? null
                                    : () => context.read<OccasionCubit>().addOccasion(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.primaryBlue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: state is AddOccasionLoadingState
                                    ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : Text(
                                  AppLocalizations.of(context)!.translate('createOccasion').toString(),
                                  style: TextStyles.textStyle12Bold.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => cubit.switchDiscountField(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.primaryBlue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(
                                  cubit.showDiscountField
                                      ? AppLocalizations.of(context)!.translate('cancel').toString()
                                      : AppLocalizations.of(context)!.translate('addDiscountCard').toString(),
                                  style: TextStyles.textStyle12Bold.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Loading overlay
                if (state is AddOccasionLoadingState)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(child: LoadingAnimationWidget()),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: ColorManager.gray.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyles.textStyle16Bold.copyWith(color: ColorManager.primaryBlue),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context,
      {required String label,
        required String value,
        bool isMultiLine = false,
        bool isLink = false,
        bool isTotal = false,
        Color? valueColor,
        String? subtitle
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$label: ",
                style: TextStyles.textStyle12Bold.copyWith(
                  color: ColorManager.black,
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyles.textStyle12Bold.copyWith(
                    color: valueColor ?? ColorManager.primaryBlue,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                    fontSize: isTotal ? 14 : 12,
                    decoration: isLink ? TextDecoration.underline : null,
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8),
              child: Text(
                subtitle,
                style: TextStyles.textStyle12Regular.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}