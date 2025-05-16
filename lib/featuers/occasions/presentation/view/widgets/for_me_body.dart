import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/occasions/data/models/cityModel.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/occasion_summary.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/open_image.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/loading_widget.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../../utiles/cashe_helper/cashe_helper.dart';

class ForMeBody extends StatefulWidget {
  const ForMeBody({super.key});

  @override
  State<ForMeBody> createState() => _ForMeBodyState();
}

class _ForMeBodyState extends State<ForMeBody> with WidgetsBindingObserver {
  GlobalKey<FormState> forMeFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<OccasionCubit>().getOccasionTaxes();
    context.read<OccasionCubit>().getAllCity();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionCubit, OccasionState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<OccasionCubit>();
        final mediaQuery = MediaQuery.sizeOf(context);
        return GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: (state is GetOccasionTaxesLoadingState) || (state is GetAllCityLoadingState) ? Center(child: LoadingAnimationWidget()) :SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.width * 0.02, vertical: SizeConfig.height * 0.02),
            child: Form(
              key: forMeFormKey,
              child: Column(
                crossAxisAlignment: CashHelper.languageKey == 'ar'
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  /// Public or Private Switch
                  _buildSectionCard(
                    context,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate('public').toString(),
                          style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                        ),
                        SizedBox(width: SizeConfig.width * 0.03),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Switch(
                            value: cubit.isPublicValue,
                            onChanged: (value) => cubit.switchIsPublic(),
                            activeColor: ColorManager.primaryBlue,
                            inactiveThumbColor: ColorManager.gray,
                          ),
                        ),
                        SizedBox(width: SizeConfig.width * 0.03),
                        Text(
                          AppLocalizations.of(context)!.translate('private').toString(),
                          style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.height * 0.02),

                  /// Person Name
                  Visibility(
                    visible: !cubit.isForMe,
                    child: _buildSectionCard(
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.translate('personName').toString(),
                            style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                          ),
                          SizedBox(height: SizeConfig.height * 0.01),
                          DefaultTextField(
                            controller: cubit.nameController,
                            hintText: AppLocalizations.of(context)!.translate('personNameHint').toString(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                customToast(
                                  title: AppLocalizations.of(context)!.translate('validatePersonName').toString(),
                                  color: Colors.red,
                                );
                                return AppLocalizations.of(context)!.translate('validatePersonName').toString();
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            fillColor: ColorManager.gray.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.height * 0.02),

                  /// Occasion Type
                  _buildSectionCard(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate('occasionType').toString(),
                          style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                        ),
                        SizedBox(height: SizeConfig.height * 0.01),
                        state is GetOccasionTaxesLoadingState
                            ? const LoadingAnimationWidget()
                            : Container(
                          height: SizeConfig.height * 0.06,
                          decoration: BoxDecoration(
                            color: ColorManager.gray.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: cubit.dropdownOccasionType.isEmpty ? null : cubit.dropdownOccasionType,
                              hint: Text(AppLocalizations.of(context)!.translate('occasionTypeHint').toString()),
                              icon: const Icon(Icons.keyboard_arrow_down, color: ColorManager.primaryBlue),
                              elevation: 16,
                              style: TextStyles.textStyle16Regular.copyWith(color: ColorManager.black),
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  cubit.dropdownOccasionType = newValue!;
                                });
                              },
                              items: cubit.occasionTypeItems.map<DropdownMenuItem<String>>((dynamic value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: TextStyles.textStyle16Regular.copyWith(color: ColorManager.black)),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.height * 0.02),

                  /// Gift Type
                  _buildSectionCard(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.translate('giftType').toString()}: ",
                          style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                        ),
                        SizedBox(height: SizeConfig.height * 0.01),
                        Row(
                          mainAxisAlignment: CashHelper.languageKey == 'ar' ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            _buildGiftTypeButton(
                              context,
                              title: AppLocalizations.of(context)!.translate('gift').toString(),
                              isActive: cubit.isPresent,
                              onTap: () {
                                // cubit.giftType = 'هدية';
                                // cubit.isPresent = true;
                                // cubit.isMoney = false;
                                UserDataFromStorage.giftType = cubit.giftType;
                                cubit.switchGiftType(present: true);
                              },
                            ),
                            SizedBox(width: SizeConfig.width * 0.05),
                            _buildGiftTypeButton(
                              context,
                              title: AppLocalizations.of(context)!.translate('money').toString(),
                              isActive: cubit.isMoney,
                              onTap: () {
                                // cubit.giftType = 'مبلغ مالي';
                                // cubit.isPresent = false;
                                // cubit.isMoney = true;
                                UserDataFromStorage.giftType = cubit.giftType;
                                cubit.switchGiftType(present: false);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.height * 0.02),

                  /// Gift Section
                  Visibility(
                    visible: cubit.isPresent,
                    child: _buildSectionCard(
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.translate('giftName').toString(),
                            style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                          ),
                          SizedBox(height: SizeConfig.height * 0.01),
                          DefaultTextField(
                            controller: cubit.giftNameController,
                            hintText: AppLocalizations.of(context)!.translate('giftNameHint').toString(),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                final validationMessage = AppLocalizations.of(context)!.translate('validateGiftName').toString();
                                customToast(
                                  title: validationMessage,
                                  color: Colors.red,
                                );
                                return validationMessage;
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            fillColor: ColorManager.gray.withOpacity(0.5),
                          ),
                          SizedBox(height: SizeConfig.height * 0.02),

                          Text(
                            AppLocalizations.of(context)!.translate('link').toString(),
                            style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                          ),
                          SizedBox(height: SizeConfig.height * 0.01),
                          DefaultTextField(
                            controller: cubit.linkController,
                            hintText: AppLocalizations.of(context)!.translate('linkHint').toString(),
                           validator: (value) {
                              if (value!.trim().isEmpty) {
                                final validationMessage = AppLocalizations.of(context)!.translate('validateLink').toString();
                                customToast(
                                  title: validationMessage,
                                  color: Colors.red,
                                );
                                return validationMessage;
                              }
                              final uri = Uri.tryParse(value);
                              if (uri == null || !(uri.isScheme('http') || uri.isScheme('https')) || uri.host.isEmpty || !uri.host.contains('.')) {
                                final validationMessage = AppLocalizations.of(context)!.translate('vaildLink').toString();
                                customToast(
                                  title: validationMessage,
                                  color: Colors.red,
                                );
                                return validationMessage;
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            fillColor: ColorManager.gray.withOpacity(0.5),
                          ),
                          SizedBox(height: SizeConfig.height * 0.02),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.translate('gifPicture').toString()} ",
                                style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: cubit.pickGiftImage,
                                icon: Icon(
                                  Icons.file_upload_outlined,
                                  size: mediaQuery.height * 0.04,
                                  color: ColorManager.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.height * 0.01),
                          cubit.images.isEmpty
                              ? Container(
                            height: mediaQuery.height * 0.1,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: ColorManager.gray.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(child: Icon(Icons.image, color: ColorManager.primaryBlue)),
                          )
                              : SizedBox(
                            height: mediaQuery.height * 0.12,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: cubit.images.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: SizeConfig.width * 0.02),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: mediaQuery.height * 0.1,
                                        width: mediaQuery.height * 0.1,
                                        decoration: BoxDecoration(
                                          color: ColorManager.gray.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.file(
                                            cubit.images[index],
                                            fit: BoxFit.cover,
                                            height: mediaQuery.height * 0.1,
                                            width: mediaQuery.height * 0.1,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () => cubit.removeImage(index),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: ColorManager.primaryBlue,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              size: mediaQuery.height * 0.02,
                                              color: ColorManager.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: SizeConfig.height * 0.02),

                          Text(
                            "${AppLocalizations.of(context)!.translate('giftAmount').toString()} ",
                            style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                          ),
                          SizedBox(height: SizeConfig.height * 0.01),
                          Row(
                            children: [
                              Expanded(
                                child: DefaultTextField(
                                  controller: cubit.moneyAmountController,
                                  hintText: AppLocalizations.of(context)!.translate('giftAmountHint').toString(),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      final validationMessage = AppLocalizations.of(context)!.translate('validateGiftAmount').toString();
                                      customToast(
                                        title: validationMessage,
                                        color: Colors.red,
                                      );
                                      return validationMessage;
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  fillColor: ColorManager.gray.withOpacity(0.5),
                                ),
                              ),
                              SizedBox(width: SizeConfig.width * 0.03),
                              Text(
                                AppLocalizations.of(context)!.translate('rsa').toString(),
                                style: TextStyles.textStyle18Regular,
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.height * 0.02),

                          /// Packaging Options
                          Row(
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.translate('packaging').toString()}: ",
                                style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                              ),
                            ],
                          ),

                          /// Package Selection
                          Visibility(
                            visible: cubit.giftWithPackage,
                            child: Column(
                              children: [
                                SizedBox(height: SizeConfig.height * 0.02),
                                Text(
                                  AppLocalizations.of(context)!.translate('packagingOpenImageNote').toString(),
                                  style: TextStyles.textStyle12Regular.copyWith(color: ColorManager.gray, fontStyle: FontStyle.italic),
                                ),
                                SizedBox(height: SizeConfig.height * 0.02),
                                state is GetOccasionTaxesLoadingState
                                    ? const LoadingAnimationWidget()
                                    : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildPackageOption(
                                      context,
                                      price: cubit.giftPackageListPrice[0].toString(),
                                      imageUrl: cubit.giftPackageListImage[0].toString(),
                                      isSelected: cubit.giftWithPackageType == int.parse(cubit.giftPackageListPrice[0].toString()),
                                      onTap: () => cubit.switchGiftWithPackageType(
                                        int.parse(cubit.giftPackageListPrice[0].toString()),
                                        cubit.giftPackageListImage[0].toString(),
                                      ),
                                    ),
                                    _buildPackageOption(
                                      context,
                                      price: cubit.giftPackageListPrice[1].toString(),
                                      imageUrl: cubit.giftPackageListImage[1].toString(),
                                      isSelected: cubit.giftWithPackageType == int.parse(cubit.giftPackageListPrice[1].toString()),
                                      onTap: () => cubit.switchGiftWithPackageType(
                                        int.parse(cubit.giftPackageListPrice[1].toString()),
                                        cubit.giftPackageListImage[1].toString(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.height * 0.02),

                  /// Money Section
                  Visibility(
                    visible: cubit.isMoney,
                    child: _buildSectionCard(
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('moneyAmount').toString()} ",
                            style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                          ),
                          SizedBox(height: SizeConfig.height * 0.01),
                          Row(
                            children: [
                              Expanded(
                                child: DefaultTextField(
                                  controller: cubit.moneyAmountController,
                                  hintText: AppLocalizations.of(context)!.translate('moneyAmountHint').toString(),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      final validationMessage = AppLocalizations.of(context)!.translate('validateMoneyAmount').toString();
                                      customToast(
                                        title: validationMessage,
                                        color: Colors.red,
                                      );
                                      return validationMessage;
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  fillColor: ColorManager.gray.withOpacity(0.5),
                                ),
                              ),
                              SizedBox(width: SizeConfig.width * 0.03),
                              Text(
                                AppLocalizations.of(context)!.translate('rsa').toString(),
                                style: TextStyles.textStyle18Regular,
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.height * 0.02),

                          /// Packaging Options
                          Row(
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.translate('packaging').toString()}: ",
                                style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                              ),
                            ],
                          ),

                          Visibility(
                            visible: cubit.giftWithPackage,
                            child: Column(
                              children: [
                                SizedBox(height: SizeConfig.height * 0.02),
                                Text(
                                  AppLocalizations.of(context)!.translate('packagingOpenImageNote').toString(),
                                  style: TextStyles.textStyle12Regular.copyWith(color: ColorManager.gray, fontStyle: FontStyle.italic),
                                ),
                                SizedBox(height: SizeConfig.height * 0.02),
                                state is GetOccasionTaxesLoadingState
                                    ? const LoadingAnimationWidget()
                                    : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildPackageOption(
                                      context,
                                      price: cubit.moneyPackageListPrice[0].toString(),
                                      imageUrl: cubit.moneyPackageListImage[0].toString(),
                                      isSelected: cubit.moneyWithPackageType == int.parse(cubit.moneyPackageListPrice[0].toString()),
                                      onTap: () => cubit.switchMoneyWithPackageType(
                                        int.parse(cubit.moneyPackageListPrice[0].toString()),
                                        cubit.moneyPackageListImage[0].toString(),
                                      ),
                                    ),
                                    _buildPackageOption(
                                      context,
                                      price: cubit.moneyPackageListPrice[1].toString(),
                                      imageUrl: cubit.moneyPackageListImage[1].toString(),
                                      isSelected: cubit.moneyWithPackageType == int.parse(cubit.moneyPackageListPrice[1].toString()),
                                      onTap: () => cubit.switchMoneyWithPackageType(
                                        int.parse(cubit.moneyPackageListPrice[1].toString()),
                                        cubit.moneyPackageListImage[1].toString(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: SizeConfig.height * 0.02),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.height * 0.02),

                  /// Delivery Data Button
                  InkWell(
                    onTap: cubit.switchShowDeliveryData,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ColorManager.primaryBlue.withOpacity(0.1), ColorManager.primaryBlue.withOpacity(0.3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.translate('receivingData').toString(),
                        style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.primaryBlue),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.height * 0.02),

                  /// Delivery Data
                  Visibility(
                    visible: cubit.showDeliveryData && (cubit.isPresent || (!cubit.isPresent && cubit.giftWithPackage)),
                    child: _buildSectionCard(
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.translate('City').toString(),
                            style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                          ),
                          SizedBox(height: SizeConfig.height * 0.01),
                          Container(
                            height: SizeConfig.height * 0.06,
                            decoration: BoxDecoration(
                              color: ColorManager.gray.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: cubit.dropdownCity.isEmpty ? null : cubit.dropdownCity,
                                hint: Text(AppLocalizations.of(context)!.translate('enterYourCity').toString()),
                                icon: const Icon(Icons.keyboard_arrow_down, color: ColorManager.primaryBlue),
                                elevation: 16,
                                style: TextStyles.textStyle16Regular.copyWith(color: ColorManager.black),
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    cubit.dropdownCity = newValue!;
                                    cubit.getQuarters(city: newValue);
                                  });
                                },
                                items: cubit.allCity.map<DropdownMenuItem<String>>((dynamic value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyles.textStyle16Regular.copyWith(color: ColorManager.black)),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),

                          Visibility(
                            visible: cubit.dropdownCity.isNotEmpty,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: SizeConfig.height * 0.01),

                                Text(
                                  AppLocalizations.of(context)!.translate('theDistrict').toString(),
                                  style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                                ),
                                SizedBox(height: SizeConfig.height * 0.01),
                                state is GetAllQuartersLoadingState? LoadingAnimationWidget() :Container(
                                  height: SizeConfig.height * 0.06,
                                  decoration: BoxDecoration(
                                    color: ColorManager.gray.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: cubit.dropdownQuarter.isEmpty ? null : cubit.dropdownQuarter,
                                      hint: Text(AppLocalizations.of(context)!.translate('theDistrictHint').toString()),
                                      icon: const Icon(Icons.keyboard_arrow_down, color: ColorManager.primaryBlue),
                                      elevation: 16,
                                      style: TextStyles.textStyle16Regular.copyWith(color: ColorManager.black),
                                      isExpanded: true,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          cubit.dropdownQuarter = newValue!;
                                          cubit.giftDeliveryStreetController.text = newValue;
                                        });
                                      },
                                      items: cubit.allQuarters.map<DropdownMenuItem<String>>((dynamic value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: TextStyles.textStyle16Regular.copyWith(color: ColorManager.black)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),


                          SizedBox(height: SizeConfig.height * 0.01),
                          // DefaultTextField(
                          //   controller: cubit.giftDeliveryStreetController,
                          //   hintText: AppLocalizations.of(context)!.translate('theDistrictHint').toString(),
                          //   validator: (value) {
                          //     if (value!.isEmpty) {
                          //       final validationMessage = AppLocalizations.of(context)!.translate('validateTheDistrict').toString();
                          //       customToast(
                          //         title: validationMessage,
                          //         color: Colors.red,
                          //       );
                          //       return validationMessage;
                          //     }
                          //     return null;
                          //   },
                          //   keyboardType: TextInputType.text,
                          //   textInputAction: TextInputAction.next,
                          //   fillColor: ColorManager.gray.withOpacity(0.5),
                          // ),
                          // SizedBox(height: SizeConfig.height * 0.02),

                          Text(
                            AppLocalizations.of(context)!.translate('moneyReceiverPhone').toString(),
                            style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                          ),
                          SizedBox(height: SizeConfig.height * 0.01),
                          DefaultTextField(
                            controller: cubit.giftReceiverNumberController,
                            hintText: AppLocalizations.of(context)!.translate('moneyReceiverPhoneHint').toString(),
                           validator: (value) {
                              if (value!.isEmpty) {
                                final validationMessage = AppLocalizations.of(context)!.translate('validateMoneyReceiverPhone').toString();
                                customToast(
                                  title: validationMessage,
                                  color: Colors.red,
                                );
                                return validationMessage;
                              }
                              if (value.length != 10) {
                                final validationMessage = AppLocalizations.of(context)!.translate('validatePhone2').toString();
                                customToast(
                                  title: validationMessage,
                                  color: Colors.red,
                                );
                                return validationMessage;
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            fillColor: ColorManager.gray.withOpacity(0.5),
                          ),
                          SizedBox(height: SizeConfig.height * 0.02),

                          Row(
                            mainAxisAlignment: CashHelper.languageKey == 'ar' ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.translate('isContainsNames').toString()} ",
                                style: TextStyles.textStyle12Bold.copyWith(color: ColorManager.black),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Switch(
                                  value: cubit.giftContainsNameValue,
                                  onChanged: (value) => cubit.switchGiftContainsName(),
                                  activeColor: ColorManager.primaryBlue,
                                  inactiveThumbColor: ColorManager.gray,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.height * 0.02),

                          InkWell(
                            onTap: cubit.switchShowGiftCard,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [ColorManager.primaryBlue.withOpacity(0.1), ColorManager.primaryBlue.withOpacity(0.3)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.translate('giftCard').toString(),
                                style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.primaryBlue),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: cubit.showGiftCard,
                            child: Column(
                              children: [
                                SizedBox(height: SizeConfig.height * 0.01),
                                DefaultTextField(
                                  controller: cubit.moneyGiftMessageController,
                                  maxLines: 3,
                                  hintText: AppLocalizations.of(context)!.translate('giftCardHint').toString(),
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  fillColor: ColorManager.gray.withOpacity(0.5),
                                  validator: (value) =>null,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfig.height * 0.02),

                          InkWell(
                            onTap: cubit.switchShowNote,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [ColorManager.primaryBlue.withOpacity(0.1), ColorManager.primaryBlue.withOpacity(0.3)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.translate('note').toString(),
                                style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.primaryBlue),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: cubit.showNote,
                            child: Column(
                              children: [
                                SizedBox(height: SizeConfig.height * 0.01),
                                DefaultTextField(
                                  controller: cubit.giftDeliveryNoteController,
                                  maxLines: 3,
                                  hintText: AppLocalizations.of(context)!.translate('noteHint').toString(),
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  fillColor: ColorManager.gray.withOpacity(0.5),
                                  validator: (value) =>null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.height * 0.03),

                  /// Continue Button
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        if (cubit.dropdownOccasionType.isEmpty) {
                          customToast(
                            title: AppLocalizations.of(context)!.translate('validateOccasionType').toString(),
                            color: Colors.red,
                          );
                          return;
                        }
                        if (!forMeFormKey.currentState!.validate()) {
                          return;
                        }
                        if (cubit.isPresent== false && cubit.isMoney== false){
                          customToast(
                            title: AppLocalizations.of(context)!.translate('validateGiftType').toString(),
                            color: Colors.red,
                          );
                          return;
                        }

                        if (cubit.images.isEmpty && cubit.isPresent) {
                          customToast(
                            title: AppLocalizations.of(context)!.translate('validateImage').toString(),
                            color: Colors.red,
                          );
                          return;
                        }
                        if(cubit.dropdownCity.isEmpty || cubit.giftDeliveryStreetController.text.isEmpty || cubit.giftReceiverNumberController.text.isEmpty){
                          customToast(
                            title: AppLocalizations.of(context)!.translate('deliveryDataValidate').toString(),
                            color: Colors.red,
                          );
                          return;
                        }
                        cubit.getTotalGiftPrice();
                        customPushNavigator(context, OccasionSummary());
                      },
                      child: Container(
                        height: mediaQuery.height * 0.06,
                        width: mediaQuery.width * 0.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [ColorManager.primaryBlue, ColorManager.primaryBlue.withOpacity(0.8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.primaryBlue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.translate('continue').toString(),
                            style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.height * 0.03),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard(BuildContext context, {required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.height * 0.02),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildGiftTypeButton(
      BuildContext context, {
        required String title,
        required bool isActive,
        required VoidCallback onTap,
        double? width,
      }) {
    final mediaQuery = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: mediaQuery.height * 0.055,
        width: width ?? mediaQuery.width * 0.25,
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
            colors: [ColorManager.primaryBlue, ColorManager.primaryBlue.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isActive ? null : ColorManager.gray.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: ColorManager.primaryBlue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyles.textStyle16Bold.copyWith(color: isActive ? ColorManager.white : ColorManager.black),
          ),
        ),
      ),
    );
  }

  Widget _buildPackageOption(
      BuildContext context, {
        required String price,
        required String imageUrl,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    final mediaQuery = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: onTap,
      onLongPress: (){
        customPushNavigator(context, ImageViewerScreen(imageUrl: imageUrl,));
      },
      child: SizedBox(
        height: mediaQuery.height * 0.1,
        width: mediaQuery.height * 0.1,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isSelected ? ColorManager.primaryBlue.withOpacity(0.2) : ColorManager.gray.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? Border.all(color: ColorManager.primaryBlue, width: 2) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.height * 0.01),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    height: mediaQuery.height * 0.08,
                    width: mediaQuery.height * 0.08,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: mediaQuery.height * 0.04,
              width: mediaQuery.height * 0.04,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? ColorManager.primaryBlue : ColorManager.white,
                borderRadius: BorderRadius.circular(500),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                price,
                style: TextStyles.textStyle12Bold.copyWith(
                  color: isSelected ? ColorManager.white : ColorManager.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}