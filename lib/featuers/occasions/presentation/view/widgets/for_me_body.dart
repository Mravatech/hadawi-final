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
    context.read<OccasionCubit>().getUserToken();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String total='';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OccasionCubit, OccasionState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<OccasionCubit>();
        final mediaQuery = MediaQuery.sizeOf(context);
        
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: (state is GetOccasionTaxesLoadingState) || (state is GetAllCityLoadingState) 
              ? const Center(child: LoadingAnimationWidget()) 
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.width * 0.05,
                      vertical: mediaQuery.height * 0.02,
                    ),
                    child: Form(
                      key: forMeFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSectionCard(
                            context: context,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate('occasionDetails').toString(),
                                  style: TextStyles.textStyle18Bold.copyWith(
                                    color: ColorManager.primaryBlue,
                                    fontSize: mediaQuery.height * 0.022,
                                  ),
                                ),
                                SizedBox(height: mediaQuery.height * 0.02),
                                
                                // Public/Private Switch
                                _buildToggleRow(
                                  context: context,
                                  title: AppLocalizations.of(context)!.translate('visibility').toString(),
                                  value: cubit.isPublicValue,
                                  onChanged: (value) => cubit.switchIsPublic(),
                                  leftLabel: AppLocalizations.of(context)!.translate('public').toString(),
                                  rightLabel: AppLocalizations.of(context)!.translate('private').toString(),
                                ),
                                
                                SizedBox(height: mediaQuery.height * 0.02),
                                
                                // Occasion Type Dropdown
                                _buildDropdownField(
                                  context: context,
                                  label: AppLocalizations.of(context)!.translate('occasionType').toString(),
                                  value: cubit.dropdownOccasionType.isEmpty ? null : cubit.dropdownOccasionType,
                                  hint: AppLocalizations.of(context)!.translate('occasionTypeHint').toString(),
                                  items: cubit.occasionTypeItems.map((value) {
                                    total = '${value.values.first} - ${value.values.last}';
                                    return DropdownMenuItem<String>(
                                      value: '${value.values.first} - ${value.values.last}',
                                      child: Text(
                                        '${value.values.first} - ${value.values.last}',
                                        style: TextStyles.textStyle12Regular.copyWith(
                                          color: ColorManager.black.withOpacity(0.8),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      print('(: $value');
                                      cubit.dropdownOccasionType = value!;
                                      print(cubit.dropdownOccasionType);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: mediaQuery.height * 0.02),
                          
                          // Gift Type Selection
                          _buildSectionCard(
                            context: context,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate('giftType').toString(),
                                  style: TextStyles.textStyle16Bold.copyWith(
                                    color: ColorManager.primaryBlue,
                                  ),
                                ),
                                SizedBox(height: mediaQuery.height * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildGiftTypeButton(
                                      context: context,
                                      title: AppLocalizations.of(context)!.translate('gift').toString(),
                                      isActive: cubit.isPresent,
                                      onTap: () {
                                        UserDataFromStorage.giftType = cubit.giftType;
                                        cubit.switchGiftType(present: true);
                                      },
                                    ),
                                    _buildGiftTypeButton(
                                      context: context,
                                      title: AppLocalizations.of(context)!.translate('money').toString(),
                                      isActive: cubit.isMoney,
                                      onTap: () {
                                        UserDataFromStorage.giftType = cubit.giftType;
                                        cubit.switchGiftType(present: false);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: mediaQuery.height * 0.02),
                          
                          // Gift Details Section
                          Visibility(
                            visible: cubit.isPresent,
                            child: _buildSectionCard(
                              context: context,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.translate('giftDetails').toString(),
                                    style: TextStyles.textStyle18Bold.copyWith(
                                      color: ColorManager.primaryBlue,
                                    ),
                                  ),
                                  SizedBox(height: mediaQuery.height * 0.02),
                                  
                                  // Gift Name Field
                                  _buildTextField(
                                    context: context,
                                    controller: cubit.giftNameController,
                                    label: AppLocalizations.of(context)!.translate('giftName').toString(),
                                    hint: AppLocalizations.of(context)!.translate('giftNameHint').toString(),
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return AppLocalizations.of(context)!.translate('validateGiftName').toString();
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  SizedBox(height: mediaQuery.height * 0.02),
                                  
                                  // Gift Link Field
                                  _buildTextField(
                                    context: context,
                                    controller: cubit.linkController,
                                    label: AppLocalizations.of(context)!.translate('link').toString(),
                                    hint: AppLocalizations.of(context)!.translate('linkHint').toString(),
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return AppLocalizations.of(context)!.translate('validateLink').toString();
                                      }
                                      final uri = Uri.tryParse(value);
                                      if (uri == null || !(uri.isScheme('http') || uri.isScheme('https')) || uri.host.isEmpty || !uri.host.contains('.')) {
                                        return AppLocalizations.of(context)!.translate('vaildLink').toString();
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  SizedBox(height: mediaQuery.height * 0.02),
                                  
                                  // Gift Images
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.translate('gifPicture').toString(),
                                            style: TextStyles.textStyle16Bold.copyWith(color: ColorManager.black),
                                          ),
                                          IconButton(
                                            onPressed: cubit.pickGiftImage,
                                            icon: Icon(
                                              Icons.add_photo_alternate_outlined,
                                              color: ColorManager.primaryBlue,
                                              size: 28,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        height: mediaQuery.height * 0.15,
                                        decoration: BoxDecoration(
                                          color: ColorManager.gray.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: ColorManager.gray.withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: cubit.images.isEmpty
                                          ? Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.image_outlined,
                                                    color: ColorManager.gray,
                                                    size: 32,
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    AppLocalizations.of(context)!.translate('addImages').toString(),
                                                    style: TextStyles.textStyle12Regular.copyWith(
                                                      color: ColorManager.gray,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: cubit.images.length,
                                              padding: EdgeInsets.all(8),
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  margin: EdgeInsets.only(right: 8),
                                                  width: mediaQuery.height * 0.15,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.1),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: Image.file(
                                                          cubit.images[index],
                                                          fit: BoxFit.cover,
                                                          width: double.infinity,
                                                          height: double.infinity,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 4,
                                                        right: 4,
                                                        child: GestureDetector(
                                                          onTap: () => cubit.removeImage(index),
                                                          child: Container(
                                                            padding: EdgeInsets.all(4),
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              shape: BoxShape.circle,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.black.withOpacity(0.1),
                                                                  blurRadius: 4,
                                                                  offset: Offset(0, 2),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Icon(
                                                              Icons.close,
                                                              color: ColorManager.error,
                                                              size: 16,
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
                                    ],
                                  ),
                                  
                                  SizedBox(height: mediaQuery.height * 0.02),
                                  
                                  // Gift Amount Field
                                  _buildTextField(
                                    context: context,
                                    controller: cubit.moneyAmountController,
                                    label: AppLocalizations.of(context)!.translate('giftAmount').toString(),
                                    hint: AppLocalizations.of(context)!.translate('giftAmountHint').toString(),
                                    keyboardType: TextInputType.number,
                                    suffix: Text(
                                      AppLocalizations.of(context)!.translate('rsa').toString(),
                                      style: TextStyles.textStyle16Regular.copyWith(
                                        color: ColorManager.primaryBlue,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return AppLocalizations.of(context)!.translate('validateGiftAmount').toString();
                                      }
                                      return null;
                                    },
                                  ),


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
                                        SizedBox(height: SizeConfig.height * 0.02),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: mediaQuery.height * 0.02),

                          // Money Details Section
                          Visibility(
                            visible: cubit.isMoney,
                            child: _buildSectionCard(
                              context: context,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   AppLocalizations.of(context)!.translate('moneyDetails').toString(),
                                  //   style: TextStyles.textStyle18Bold.copyWith(
                                  //     color: ColorManager.primaryBlue,
                                  //   ),
                                  // ),
                                  SizedBox(height: mediaQuery.height * 0.02),
                                  
                                  // Money Amount Field
                                  _buildTextField(
                                    context: context,
                                    controller: cubit.moneyAmountController,
                                    label: AppLocalizations.of(context)!.translate('moneyAmount').toString(),
                                    hint: AppLocalizations.of(context)!.translate('moneyAmountHint').toString(),
                                    keyboardType: TextInputType.number,
                                    suffix: Text(
                                      AppLocalizations.of(context)!.translate('rsa').toString(),
                                      style: TextStyles.textStyle16Regular.copyWith(
                                        color: ColorManager.primaryBlue,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return AppLocalizations.of(context)!.translate('validateMoneyAmount').toString();
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: mediaQuery.height * 0.02),
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

                          SizedBox(height: mediaQuery.height * 0.02),

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

                          // Delivery Data Section
                          Visibility(
                            visible: cubit.showDeliveryData && (cubit.isPresent || (!cubit.isPresent && cubit.giftWithPackage)),
                            child: _buildSectionCard(
                              context: context,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.translate('deliveryDetails').toString(),
                                    style: TextStyles.textStyle18Bold.copyWith(
                                      color: ColorManager.primaryBlue,
                                    ),
                                  ),
                                  SizedBox(height: mediaQuery.height * 0.02),

                                  // City Dropdown
                                  _buildDropdownField(
                                    context: context,
                                    label: AppLocalizations.of(context)!.translate('City').toString(),
                                    value: cubit.dropdownCity.isEmpty ? null : cubit.dropdownCity,
                                    hint: AppLocalizations.of(context)!.translate('enterYourCity').toString(),
                                    items: cubit.allCity.map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value.toString(),
                                        child: Text(
                                          value.toString(),
                                          style: TextStyles.textStyle12Regular.copyWith(
                                            color: ColorManager.black.withOpacity(0.8),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        cubit.dropdownCity = value!;
                                        cubit.getQuarters(city: value);
                                      });
                                    },
                                  ),

                                  SizedBox(height: mediaQuery.height * 0.02),

                                  // District Dropdown
                                  Visibility(
                                    visible: cubit.dropdownCity.isNotEmpty,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        state is GetAllQuartersLoadingState
                                          ? Center(child: LoadingAnimationWidget())
                                          : _buildDropdownField(
                                              context: context,
                                              label: AppLocalizations.of(context)!.translate('theDistrict').toString(),
                                              value: cubit.dropdownQuarter.isEmpty ? null : cubit.dropdownQuarter,
                                              hint: AppLocalizations.of(context)!.translate('theDistrictHint').toString(),
                                              items: cubit.allQuarters.map((value) {
                                                return DropdownMenuItem<String>(
                                                  value: value.toString(),
                                                  child: Text(
                                                    value.toString(),
                                                    style: TextStyles.textStyle12Regular.copyWith(
                                                      color: ColorManager.black.withOpacity(0.8),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  cubit.dropdownQuarter = value!;
                                                  cubit.giftDeliveryStreetController.text = value;
                                                });
                                              },
                                            ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: mediaQuery.height * 0.02),

                                  // Phone Number Field
                                  _buildTextField(
                                    context: context,
                                    controller: cubit.giftReceiverNumberController,
                                    label: AppLocalizations.of(context)!.translate('moneyReceiverPhone').toString(),
                                    hint: AppLocalizations.of(context)!.translate('moneyReceiverPhoneHint').toString(),
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return AppLocalizations.of(context)!.translate('validateMoneyReceiverPhone').toString();
                                      }
                                      if (value.length != 10) {
                                        return AppLocalizations.of(context)!.translate('validatePhone2').toString();
                                      }
                                      return null;
                                    },
                                  ),

                                  SizedBox(height: mediaQuery.height * 0.02),

                                  // Contains Names Switch
                                  _buildToggleRow(
                                    context: context,
                                    title: AppLocalizations.of(context)!.translate('isContainsNames').toString(),
                                    value: cubit.giftContainsNameValue,
                                    onChanged: (value) => cubit.switchGiftContainsName(),
                                    leftLabel: AppLocalizations.of(context)!.translate('yes').toString(),
                                    rightLabel: AppLocalizations.of(context)!.translate('no').toString(),
                                  ),

                                  SizedBox(height: mediaQuery.height * 0.02),

                                  // Gift Card Section
                                  _buildExpandableSection(
                                    context: context,
                                    title: AppLocalizations.of(context)!.translate('giftCard').toString(),
                                    isExpanded: cubit.showGiftCard,
                                    onTap: cubit.switchShowGiftCard,
                                    child: _buildTextField(
                                      context: context,
                                      controller: cubit.moneyGiftMessageController,
                                      label: '',
                                      hint: AppLocalizations.of(context)!.translate('giftCardHint').toString(),
                                      keyboardType: TextInputType.multiline,
                                      validator: (value) => null,
                                    ),
                                  ),

                                  SizedBox(height: mediaQuery.height * 0.02),

                                  // Notes Section
                                  _buildExpandableSection(
                                    context: context,
                                    title: AppLocalizations.of(context)!.translate('note').toString(),
                                    isExpanded: cubit.showNote,
                                    onTap: cubit.switchShowNote,
                                    child: _buildTextField(
                                      context: context,
                                      controller: cubit.giftDeliveryNoteController,
                                      label: '',
                                      hint: AppLocalizations.of(context)!.translate('noteHint').toString(),
                                      keyboardType: TextInputType.multiline,
                                      validator: (value) => null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: mediaQuery.height * 0.04),

                          // Continue Button
                          Center(
                            child: _buildActionButton(
                              context: context,
                              label: AppLocalizations.of(context)!.translate('continue').toString(),
                              icon: Icons.arrow_forward,
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
                                if (cubit.isPresent == false && cubit.isMoney == false) {
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
                                if (cubit.dropdownCity.isEmpty || cubit.giftDeliveryStreetController.text.isEmpty || cubit.giftReceiverNumberController.text.isEmpty) {
                                  customToast(
                                    title: AppLocalizations.of(context)!.translate('deliveryDataValidate').toString(),
                                    color: Colors.red,
                                  );
                                  return;
                                }
                                cubit.getTotalGiftPrice();
                                customPushNavigator(context, OccasionSummary());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryBlue.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildToggleRow({
    required BuildContext context,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required String leftLabel,
    required String rightLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.textStyle12Bold.copyWith(
            color: ColorManager.black.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorManager.gray.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorManager.gray.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftLabel,
                style: TextStyles.textStyle12Regular.copyWith(
                  color: value ? ColorManager.primaryBlue : ColorManager.black.withOpacity(0.5),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: ColorManager.primaryBlue,
                inactiveThumbColor: ColorManager.gray,
              ),
              Text(
                rightLabel,
                style: TextStyles.textStyle12Regular.copyWith(
                  color: !value ? ColorManager.primaryBlue : ColorManager.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.textStyle12Bold.copyWith(
            color: ColorManager.black.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: ColorManager.gray.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorManager.gray.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: TextStyles.textStyle12Regular.copyWith(
                  color: ColorManager.gray,
                ),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: ColorManager.primaryBlue,
                size: 24,
              ),
              isExpanded: true,
              items: items,
              onChanged: onChanged,
              dropdownColor: Colors.white,
              elevation: 3,
              style: TextStyles.textStyle12Regular.copyWith(
                color: ColorManager.black.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGiftTypeButton({
    required BuildContext context,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: isActive
            ? LinearGradient(
                colors: [
                  ColorManager.primaryBlue,
                  ColorManager.primaryBlue.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
          color: isActive ? null : ColorManager.gray.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? Colors.transparent : ColorManager.gray.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: isActive
            ? [
                BoxShadow(
                  color: ColorManager.primaryBlue.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
        ),
        child: Text(
          title,
          style: TextStyles.textStyle12Bold.copyWith(
            color: isActive ? Colors.white : ColorManager.black.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: TextStyles.textStyle12Bold.copyWith(
              color: ColorManager.black.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: ColorManager.gray.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorManager.gray.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyles.textStyle12Regular.copyWith(
              color: ColorManager.black.withOpacity(0.8),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyles.textStyle12Regular.copyWith(
                color: ColorManager.gray,
              ),
              suffixIcon: suffix != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: suffix,
                  )
                : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              errorStyle: TextStyles.textStyle10Regular.copyWith(
                color: ColorManager.error,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableSection({
    required BuildContext context,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorManager.primaryBlue.withOpacity(0.1), ColorManager.primaryBlue.withOpacity(0.3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyles.textStyle16Bold.copyWith(
                    color: ColorManager.primaryBlue,
                  ),
                ),
                Spacer(),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: ColorManager.primaryBlue,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          SizedBox(height: 12),
          child,
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyles.textStyle18Bold.copyWith(color: Colors.white),
              ),
              SizedBox(width: 8),
              Icon(icon, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}