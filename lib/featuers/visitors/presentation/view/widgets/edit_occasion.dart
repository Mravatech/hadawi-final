import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/data/models/occasion_model.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../../generated/assets.dart';
import '../../../../../styles/colors/color_manager.dart';
import '../../../../../styles/size_config/app_size_config.dart';
import '../../../../../styles/text_styles/text_styles.dart';
import '../../../../../utiles/cashe_helper/cashe_helper.dart';
import '../../../../../utiles/localiztion/app_localization.dart';
import '../../../../../widgets/default_text_field.dart';
import '../../../../../widgets/loading_widget.dart';

class EditOccasion extends StatefulWidget {
  final OccasionModel occasionModel;
  final bool fromHome;

  const EditOccasion(
      {super.key, required this.occasionModel, required this.fromHome});

  @override
  State<EditOccasion> createState() => _EditOccasionState();
}
String total='';

class _EditOccasionState extends State<EditOccasion> with WidgetsBindingObserver{
  // Local variables to hold initial data from database
  late String _initialPackagePrice;
  late String _initialPackageImage;
  late bool _initialGiftWithPackage;
  late int _initialGiftWithPackageType;
  late String _initialSelectedGiftPackageImage;
  
  @override
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    final cubit = context.read<OccasionCubit>();
    Future.microtask(() async {
      await cubit.getAllCity();
      await cubit.getQuarters(city: widget.occasionModel.city);
      cubit.getOccasionTaxes();
      cubit.nameController.text = widget.occasionModel.personName;
      cubit.giftNameController.text = widget.occasionModel.giftName;
      cubit.linkController.text = widget.occasionModel.giftLink;
      cubit.moneyAmountController.text = widget.occasionModel.moneyGiftAmount.toString();
      cubit.giftDeliveryStreetController.text = widget.occasionModel.district;
      cubit.dropdownQuarter = widget.occasionModel.district;
      cubit.giftReceiverNumberController.text = widget.occasionModel.receiverPhone;
      cubit.giftReceiverNameController.text = widget.occasionModel.receiverName;
      cubit.moneyGiftMessageController.text = widget.occasionModel.giftCard;
      cubit.giftDeliveryNoteController.text = widget.occasionModel.note;
      cubit.dropdownOccasionType = widget.occasionModel.type;
      cubit.giftType = widget.occasionModel.giftType;
      cubit.moneyAmountController.text = widget.occasionModel.giftPrice.toString();
      cubit.dropdownCity = widget.occasionModel.city;
      cubit.urls = widget.occasionModel.giftImage;
      cubit.isPublicValue = widget.occasionModel.isPrivate;
      
      // Set isPresent based on gift type
      cubit.isPresent = widget.occasionModel.giftType == 'هدية';
      cubit.isMoney = widget.occasionModel.giftType != 'هدية';
      debugPrint("=== GIFT TYPE INITIALIZATION ===");
      debugPrint("giftType: '${widget.occasionModel.giftType}'");
      debugPrint("isPresent set to: ${cubit.isPresent}");
      debugPrint("isMoney set to: ${cubit.isMoney}");
      
      // Store initial packaging data in local variables
      debugPrint("=== PACKAGING INITIALIZATION ===");
      debugPrint("packagePrice from model: '${widget.occasionModel.packagePrice}'");
      debugPrint("packageImage from model: '${widget.occasionModel.packageImage}'");
      
      _initialPackagePrice = widget.occasionModel.packagePrice;
      _initialPackageImage = widget.occasionModel.packageImage;
      _initialGiftWithPackage = widget.occasionModel.packagePrice.isNotEmpty;
      
      // Set up cubit with proper initial values
      cubit.giftWithPackage = _initialGiftWithPackage;
      debugPrint("giftWithPackage set to: ${cubit.giftWithPackage}");
      
      if (_initialGiftWithPackage && _initialPackagePrice.isNotEmpty) {
        // Check if the saved package price matches any of the current available packages
        int savedPackagePrice = int.parse(_initialPackagePrice);
        bool foundMatchingPackage = false;
        
        // Wait for package list to be loaded, then check for match
        Future.delayed(Duration(milliseconds: 1000), () {
          // Check the appropriate package list based on gift type
          List packageListPrice = (cubit.giftType == 'هدية') ? cubit.giftPackageListPrice : cubit.moneyPackageListPrice;
          List packageListImage = (cubit.giftType == 'هدية') ? cubit.giftPackageListImage : cubit.moneyPackageListImage;
          
          debugPrint("=== PACKAGE MATCHING DEBUG ===");
          debugPrint("savedPackagePrice: $savedPackagePrice");
          debugPrint("giftType: '${cubit.giftType}'");
          debugPrint("packageListPrice: $packageListPrice");
          debugPrint("packageListImage: $packageListImage");
          
          if (packageListPrice.isNotEmpty) {
            for (int i = 0; i < packageListPrice.length; i++) {
              int currentPackagePrice = int.parse(packageListPrice[i].toString());
              debugPrint("Checking package $i: $currentPackagePrice vs $savedPackagePrice");
              if (currentPackagePrice == savedPackagePrice) {
                // Found matching package, use it
                _initialGiftWithPackageType = savedPackagePrice;
                _initialSelectedGiftPackageImage = packageListImage.length > i 
                    ? packageListImage[i].toString() 
                    : _initialPackageImage;
                foundMatchingPackage = true;
                debugPrint("✅ Found matching package at index $i: ${savedPackagePrice}");
                break;
              }
            }
            
            if (!foundMatchingPackage) {
              // No matching package found, use the first available package
              _initialGiftWithPackageType = int.parse(packageListPrice[0].toString());
              _initialSelectedGiftPackageImage = packageListImage.isNotEmpty 
                  ? packageListImage[0].toString() 
                  : '';
              debugPrint("❌ No matching package found, using first available: ${_initialGiftWithPackageType}");
            }
          } else {
            // Fallback to saved values if package list not loaded yet
            _initialGiftWithPackageType = savedPackagePrice;
            _initialSelectedGiftPackageImage = _initialPackageImage;
            debugPrint("Package list not loaded, using saved values: ${_initialGiftWithPackageType}");
          }
          
          // Now set the cubit values from our local variables
          if (cubit.giftType == 'هدية') {
            cubit.giftWithPackageType = _initialGiftWithPackageType;
            cubit.selectedGiftPackageImage = _initialSelectedGiftPackageImage;
          } else {
            cubit.moneyWithPackageType = _initialGiftWithPackageType;
            cubit.selectedMoneyPackageImage = _initialSelectedGiftPackageImage;
          }
          cubit.packagingInitializedFromModel = true;
          
          debugPrint("Final cubit values:");
          debugPrint("giftWithPackage: ${cubit.giftWithPackage}");
          debugPrint("giftType: '${cubit.giftType}'");
          if (cubit.giftType == 'هدية') {
            debugPrint("giftWithPackageType: ${cubit.giftWithPackageType}");
            debugPrint("selectedGiftPackageImage: '${cubit.selectedGiftPackageImage}'");
          } else {
            debugPrint("moneyWithPackageType: ${cubit.moneyWithPackageType}");
            debugPrint("selectedMoneyPackageImage: '${cubit.selectedMoneyPackageImage}'");
          }
          
          // Recalculate total with correct package price
          cubit.getTotalGiftPrice();
        });
      } else {
        // Reset packaging values if no packaging
        _initialGiftWithPackageType = 0;
        _initialSelectedGiftPackageImage = '';
        cubit.giftWithPackageType = 0;
        cubit.selectedGiftPackageImage = '';
        cubit.packagingInitializedFromModel = true;
        debugPrint("Reset packaging values - giftWithPackageType: ${cubit.giftWithPackageType}");
        debugPrint("_packagingInitializedFromModel set to: true");
      }
      
      // Debug package list after loading
      debugPrint("=== PACKAGE LIST DEBUG ===");
      debugPrint("giftPackageListPrice: ${cubit.giftPackageListPrice}");
      debugPrint("giftPackageListImage: ${cubit.giftPackageListImage}");
      debugPrint("Current giftWithPackageType: ${cubit.giftWithPackageType}");
      debugPrint("Current selectedGiftPackageImage: '${cubit.selectedGiftPackageImage}'");
      
      // Calculate initial total cost after all initialization is complete
      Future.delayed(Duration(milliseconds: 200), () {
        cubit.getTotalGiftPrice();
        debugPrint("=== INITIAL TOTAL CALCULATION ===");
        debugPrint("Final giftWithPackageType: ${cubit.giftWithPackageType}");
        debugPrint("Final total: ${cubit.giftPrice}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("isPrivateeeeeeee:${context.read<OccasionCubit>().isPublicValue}");
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.gray,
        surfaceTintColor: ColorManager.gray,
        title: Text(
          AppLocalizations.of(context)!.translate('editOccasion').toString(),
          style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              Assets.imagesLogoWithoutBackground,
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
          )
        ],
      ),
      body: BlocConsumer<OccasionCubit, OccasionState>(
        listener: (context, state) {
          if(state is DisableOccasionSuccessState){
            customToast(
              title: AppLocalizations.of(context)!
                  .translate('occasionClosedMessage')
                  .toString(),
              color: ColorManager.success,
            );
            context.read<VisitorsCubit>().getOccasions().then(
                  (value) {
                customPushAndRemoveUntil(context, HomeLayout());
              },
            );
          }
          if (state is UpdateOccasionSuccessState) {
            if (widget.fromHome == true) {
              context.read<VisitorsCubit>().getOccasions().then(
                (value) {
                  customPushReplacement(context, HomeLayout());
                },
              );
            } else {
              // Navigate back to occasions list and ensure proper navigation context
              context.read<VisitorsCubit>().getOccasions().then(
                (value) {
                  // Also refresh the occasion details data
                  context.read<VisitorsCubit>().getOccasionData(occasionId: widget.occasionModel.occasionId).then(
                    (value) {
                      // Use pop instead of pushReplacement to maintain navigation stack
                      Navigator.pop(context);
                    },
                  );
                },
              );
            }
          }
        },
        builder: (context, state) {
          final cubit = context.read<OccasionCubit>();
          final mediaQuery = MediaQuery.sizeOf(context);

          return ModalProgressHUD(
            inAsyncCall: state is DisableOccasionLoadingState,
            progressIndicator: const LoadingAnimationWidget(),
            child: (state is GetOccasionTaxesLoadingState) || (state is GetAllCityLoadingState) || (state is GetAllQuartersLoadingState) ? Center(
              child: LoadingAnimationWidget(),
            ) :Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width * 0.02,
                  vertical: SizeConfig.height * 0.02),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CashHelper.languageKey == 'ar'
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    /// public or private
                    _buildSectionCard(
                      color: ColorManager.white,
                      context,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .translate('public')
                                .toString(),
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          SizedBox(width: SizeConfig.width * 0.03),
                          Switch(
                            value: cubit.isPublicValue,
                            onChanged: (value) {
                              if (UserDataFromStorage.uIdFromStorage == widget.occasionModel.personId) {
                                cubit.switchIsPublic();
                                debugPrint('updated isPublic: ${cubit.isPublicValue}');
                                // Show a toast to indicate the change needs to be saved
                                customToast(
                                  title: "Please save changes to apply",
                                  color: ColorManager.primaryBlue,
                                );
                              } else {
                                customToast(
                                  title: AppLocalizations.of(context)!
                                      .translate('notAllowed')
                                      .toString(),
                                  color: ColorManager.error,
                                );
                              }
                            },
                            activeColor: ColorManager.primaryBlue,
                            inactiveThumbColor: ColorManager.gray,
                          ),
                          SizedBox(width: SizeConfig.width * 0.03),
                          Text(
                            AppLocalizations.of(context)!
                                .translate('private')
                                .toString(),
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.height * 0.02),

                    /// person name
                    _buildSectionCard(
                      color: ColorManager.white,
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .translate('personName')
                                .toString(),
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          SizedBox(height: SizeConfig.height * 0.01),
                          DefaultTextField(
                            controller: cubit.nameController,
                            hintText: AppLocalizations.of(context)!
                                .translate('personNameHint')
                                .toString(),
                            validator: (value) => value!.isEmpty
                                ? AppLocalizations.of(context)!
                                    .translate('validatePersonName')
                                    .toString()
                                : null,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            fillColor: ColorManager.gray.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.height * 0.02),

                    /// Occasion Type
                    _buildSectionCard(
                      color: ColorManager.white,
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .translate('occasionType')
                                .toString(),
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: cubit.dropdownOccasionType.isEmpty || !cubit.occasionTypeItems.any((item) => '${item.values.first} - ${item.values.last}' == cubit.dropdownOccasionType) ? null : cubit.dropdownOccasionType,
                                      hint: Text(
                                        AppLocalizations.of(context)!.translate('occasionTypeHint').toString(),
                                      ),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: ColorManager.primaryBlue,
                                      ),
                                      elevation: 16,
                                      style: TextStyles.textStyle16Regular.copyWith(color: ColorManager.black),
                                      isExpanded: true,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          cubit.dropdownOccasionType = newValue!;
                                        });
                                      },
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
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),

                    SizedBox(height: SizeConfig.height * 0.02),

                    /// Gift Type
                    _buildSectionCard(
                      color: ColorManager.gray,
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('giftType').toString()}: ",
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          SizedBox(height: SizeConfig.height * 0.01),
                          Row(
                            mainAxisAlignment: CashHelper.languageKey == 'ar'
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              _buildGiftTypeButton(
                                context,
                                title: AppLocalizations.of(context)!
                                    .translate('gift')
                                    .toString(),
                                isActive:
                                    widget.occasionModel.giftType == 'هدية',
                                onTap: () {
                                  // cubit.giftType = 'هدية';
                                  // UserDataFromStorage.giftType = cubit.giftType;
                                  // cubit.switchGiftType();
                                },
                              ),
                              SizedBox(width: SizeConfig.width * 0.05),
                              _buildGiftTypeButton(
                                context,
                                title: AppLocalizations.of(context)!
                                    .translate('money')
                                    .toString(),
                                isActive:
                                    widget.occasionModel.giftType != 'هدية',
                                onTap: () {
                                  // cubit.giftType = 'مبلغ مالي';
                                  // UserDataFromStorage.giftType = cubit.giftType;
                                  // cubit.switchGiftType();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.height * 0.01),

                    /// gift section
                    widget.occasionModel.giftType == 'هدية'
                        ? _buildSectionCard(context,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('giftName')
                                      .toString(),
                                  style: TextStyles.textStyle18Bold
                                      .copyWith(color: ColorManager.black),
                                ),
                                SizedBox(height: SizeConfig.height * 0.01),
                                DefaultTextField(
                                  controller: cubit.giftNameController,
                                  hintText: AppLocalizations.of(context)!
                                      .translate('giftNameHint')
                                      .toString(),
                                  validator: (value) => value!.trim().isEmpty
                                      ? AppLocalizations.of(context)!
                                          .translate('validateGiftName')
                                          .toString()
                                      : null,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  fillColor: ColorManager.gray.withOpacity(0.5),
                                ),
                                SizedBox(height: SizeConfig.height * 0.02),
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('link')
                                      .toString(),
                                  style: TextStyles.textStyle18Bold
                                      .copyWith(color: ColorManager.black),
                                ),
                                SizedBox(height: SizeConfig.height * 0.01),
                                DefaultTextField(
                                  controller: cubit.linkController,
                                  hintText: AppLocalizations.of(context)!
                                      .translate('linkHint')
                                      .toString(),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .translate('validateLink')
                                          .toString();
                                    }
                                    final uri = Uri.tryParse(value);
                                    if (uri == null ||
                                        !(uri.isScheme('http') ||
                                            uri.isScheme('https')) ||
                                        uri.host.isEmpty ||
                                        !uri.host.contains('.')) {
                                      return AppLocalizations.of(context)!
                                          .translate('vaildLink')
                                          .toString();
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
                                      style: TextStyles.textStyle18Bold
                                          .copyWith(color: ColorManager.black),
                                    ),
                                    const Spacer(),
                                    UserDataFromStorage.uIdFromStorage ==
                                            widget.occasionModel.personId
                                        ? IconButton(
                                            onPressed: cubit.pickGiftImage,
                                            icon: Icon(
                                              Icons.file_upload_outlined,
                                              size: mediaQuery.height * 0.04,
                                              color: ColorManager.primaryBlue,
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.height * 0.01),
                                widget.occasionModel.giftImage.isNotEmpty
                                    ? SizedBox(
                                        height: mediaQuery.height * 0.12,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: widget
                                              .occasionModel.giftImage.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  right:
                                                      SizeConfig.width * 0.02),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height:
                                                        mediaQuery.height * 0.1,
                                                    width:
                                                        mediaQuery.height * 0.1,
                                                    decoration: BoxDecoration(
                                                      color: ColorManager.gray
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.05),
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: CachedNetworkImage(
                                                        imageUrl: widget
                                                            .occasionModel
                                                            .giftImage[index],
                                                        fit: BoxFit.cover,
                                                        height:
                                                            mediaQuery.height *
                                                                0.1,
                                                        width:
                                                            mediaQuery.height *
                                                                0.1,
                                                      ),
                                                    ),
                                                  ),
                                                  UserDataFromStorage
                                                              .uIdFromStorage ==
                                                          widget.occasionModel
                                                              .personId
                                                      ? Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              if (UserDataFromStorage
                                                                      .uIdFromStorage ==
                                                                  widget
                                                                      .occasionModel
                                                                      .personId) {
                                                                cubit.removeNetworkImage(
                                                                    index,
                                                                    widget
                                                                        .occasionModel
                                                                        .giftImage);
                                                              } else {
                                                                return;
                                                              }
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: ColorManager
                                                                    .primaryBlue,
                                                                shape: BoxShape
                                                                    .circle,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.2),
                                                                    blurRadius:
                                                                        4,
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            2),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Icon(
                                                                Icons.close,
                                                                size: mediaQuery
                                                                        .height *
                                                                    0.02,
                                                                color:
                                                                    ColorManager
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : cubit.images.isEmpty
                                        ? Container(
                                            height: mediaQuery.height * 0.1,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: ColorManager.gray
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.05),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: const Center(
                                                child: Icon(Icons.image,
                                                    color: ColorManager
                                                        .primaryBlue)),
                                          )
                                        : SizedBox(
                                            height: mediaQuery.height * 0.12,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: cubit.images.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      right: SizeConfig.width *
                                                          0.02),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height:
                                                            mediaQuery.height *
                                                                0.1,
                                                        width:
                                                            mediaQuery.height *
                                                                0.1,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: ColorManager
                                                              .gray
                                                              .withOpacity(0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.05),
                                                              blurRadius: 8,
                                                              offset:
                                                                  const Offset(
                                                                      0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: Image.file(
                                                            cubit.images[index],
                                                            fit: BoxFit.cover,
                                                            height: mediaQuery
                                                                    .height *
                                                                0.1,
                                                            width: mediaQuery
                                                                    .height *
                                                                0.1,
                                                          ),
                                                        ),
                                                      ),
                                                      UserDataFromStorage
                                                                  .uIdFromStorage ==
                                                              widget
                                                                  .occasionModel
                                                                  .personId
                                                          ? Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () => cubit
                                                                    .removeImage(
                                                                        index),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ColorManager
                                                                        .primaryBlue,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.2),
                                                                        blurRadius:
                                                                            4,
                                                                        offset: const Offset(
                                                                            0,
                                                                            2),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    size: mediaQuery
                                                                            .height *
                                                                        0.02,
                                                                    color: ColorManager
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                SizedBox(height: SizeConfig.height * 0.02),
                              ],
                            ),
                            color: ColorManager.white)
                        : SizedBox(),

                    ///  delivery
                    _buildSectionCard(
                      color: ColorManager.white,
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate('giftAmount').toString()} ",
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          SizedBox(height: SizeConfig.height * 0.01),
                          Row(
                            children: [
                              Expanded(
                                child: DefaultTextField(
                                  controller: cubit.moneyAmountController,
                                  hintText: AppLocalizations.of(context)!
                                      .translate('giftAmountHint')
                                      .toString(),
                                  validator: (value) => value!.trim().isEmpty
                                      ? AppLocalizations.of(context)!
                                          .translate('validateGiftAmount')
                                          .toString()
                                      : null,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  fillColor: ColorManager.gray.withOpacity(0.5),
                                ),
                              ),
                              SizedBox(width: SizeConfig.width * 0.03),
                              Text(
                                AppLocalizations.of(context)!
                                    .translate('rsa')
                                    .toString(),
                                style: TextStyles.textStyle18Regular,
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.height * 0.02),
                          
                          // Packaging Options Section
                          Text(
                            "${AppLocalizations.of(context)!.translate('packaging').toString()}: ",
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          SizedBox(height: SizeConfig.height * 0.01),
                          
                          // With/Without Packaging Toggle
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // With packaging
                              GestureDetector(
                                onTap: () {
                                  if (UserDataFromStorage.uIdFromStorage == widget.occasionModel.personId) {
                                    cubit.switchGiftWithPackage(true);
                                  }
                                },
                                child: Container(
                                  height: mediaQuery.height * .055,
                                  width: mediaQuery.width * .4,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: cubit.giftWithPackage
                                        ? ColorManager.primaryBlue
                                        : ColorManager.gray,
                                    borderRadius: BorderRadius.circular(mediaQuery.height * 0.05),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('withPackaging')
                                        .toString(),
                                    style: TextStyles.textStyle12Bold
                                        .copyWith(color: ColorManager.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(width: mediaQuery.width * .05),

                              // Without packaging
                              GestureDetector(
                                onTap: () {
                                  if (UserDataFromStorage.uIdFromStorage == widget.occasionModel.personId) {
                                    cubit.switchGiftWithPackage(false);
                                  }
                                },
                                child: Container(
                                  height: mediaQuery.height * .055,
                                  width: mediaQuery.width * .4,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: cubit.giftWithPackage
                                        ? ColorManager.gray
                                        : ColorManager.primaryBlue,
                                    borderRadius: BorderRadius.circular(mediaQuery.height * 0.05),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('withoutPackaging')
                                        .toString(),
                                    style: TextStyles.textStyle12Bold
                                        .copyWith(color: ColorManager.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          // Package Type Selection (only show if packaging is enabled)
                          Visibility(
                            visible: cubit.giftWithPackage,
                            child: Column(
                              children: [
                                SizedBox(height: SizeConfig.height * 0.02),
                                Text(
                                  AppLocalizations.of(context)!.translate('packagingOpenImageNote').toString(),
                                  style: TextStyles.textStyle12Regular.copyWith(
                                    color: ColorManager.gray, 
                                    fontStyle: FontStyle.italic
                                  ),
                                ),
                                SizedBox(height: SizeConfig.height * 0.02),
                                if (state is GetOccasionTaxesLoadingState)
                                  const LoadingAnimationWidget()
                                else
                                  _buildPackageSelectionRow(context, cubit, mediaQuery)
                              ],
                            ),
                          ),
                          
                          // Total Cost Display
                          SizedBox(height: SizeConfig.height * 0.02),
                          BlocBuilder<OccasionCubit, OccasionState>(
                            builder: (context, state) {
                              final cubit = context.read<OccasionCubit>();
                              final totalCost = cubit.getTotalGiftPrice();
                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(SizeConfig.height * 0.02),
                                decoration: BoxDecoration(
                                  color: ColorManager.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: ColorManager.primaryBlue.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('totalCost')
                                          .toString(),
                                      style: TextStyles.textStyle18Bold
                                          .copyWith(color: ColorManager.black),
                                    ),
                                    Text(
                                      '${totalCost.toStringAsFixed(2)} ${AppLocalizations.of(context)!.translate('rsa').toString()}',
                                      style: TextStyles.textStyle18Bold
                                          .copyWith(color: ColorManager.primaryBlue),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          
                          SizedBox(height: SizeConfig.height * 0.02),
                          Text(
                            AppLocalizations.of(context)!
                                .translate('deliveryDetails')
                                .toString(),
                            style: TextStyles.textStyle18Bold
                                .copyWith(color: ColorManager.black),
                          ),
                          SizedBox(height: SizeConfig.height * 0.02),
                          _buildSectionCard(
                            color: ColorManager.white,
                            context,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('City')
                                      .toString(),
                                  style: TextStyles.textStyle18Bold
                                      .copyWith(color: ColorManager.black),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: (widget.occasionModel.city != null && cubit.allCity.contains(widget.occasionModel.city))
                                          ? widget.occasionModel.city
                                          : (cubit.dropdownCity.isNotEmpty && cubit.allCity.contains(cubit.dropdownCity))
                                              ? cubit.dropdownCity
                                              : null,
                                      hint: Text(AppLocalizations.of(context)!
                                          .translate('enterYourCity')
                                          .toString()),
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: ColorManager.primaryBlue),
                                      elevation: 16,
                                      style: TextStyles.textStyle16Regular
                                          .copyWith(color: ColorManager.black),
                                      isExpanded: true,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          cubit.dropdownCity = newValue!;
                                          cubit.getQuarters(city: newValue);
                                        });
                                      },
                                      items: cubit
                                          .allCity
                                          .map<DropdownMenuItem<String>>(
                                              (dynamic value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyles
                                                  .textStyle16Regular
                                                  .copyWith(
                                                      color:
                                                          ColorManager.black)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),

                                Visibility(
                                  visible: cubit.dropdownCity.isNotEmpty,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            value: cubit.dropdownQuarter.isNotEmpty && cubit.allQuarters.contains(cubit.dropdownQuarter) ? cubit.dropdownQuarter : null,
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

                                SizedBox(height: SizeConfig.height * 0.02),

                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('moneyReceiverPhone')
                                      .toString(),
                                  style: TextStyles.textStyle18Bold
                                      .copyWith(color: ColorManager.black),
                                ),
                                SizedBox(height: SizeConfig.height * 0.01),
                                DefaultTextField(
                                  controller:
                                      cubit.giftReceiverNumberController,
                                  hintText: AppLocalizations.of(context)!
                                      .translate('moneyReceiverPhoneHint')
                                      .toString(),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .translate(
                                              'validateMoneyReceiverPhone')
                                          .toString();
                                    }
                                    if (value.length != 10) {
                                      return AppLocalizations.of(context)!
                                          .translate('validatePhone2')
                                          .toString();
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  fillColor: ColorManager.gray.withOpacity(0.5),
                                ),
                                SizedBox(height: SizeConfig.height * 0.02),

                                Column(
                                  children: [
                                    SizedBox(height: SizeConfig.height * 0.01),
                                    DefaultTextField(
                                      controller:
                                          cubit.moneyGiftMessageController,
                                      maxLines: 3,
                                      hintText: '',
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      fillColor:
                                          ColorManager.gray.withOpacity(0.5),
                                      validator: (value) => null,
                                    ),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.height * 0.02),

                                Column(
                                  children: [
                                    SizedBox(height: SizeConfig.height * 0.01),
                                    DefaultTextField(
                                      controller:
                                          cubit.giftDeliveryNoteController,
                                      maxLines: 3,
                                      hintText: '',
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      fillColor:
                                          ColorManager.gray.withOpacity(0.5),
                                      validator: (value) => null,
                                    ),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.height * 0.03),

                                /// Continue Button
                                UserDataFromStorage.uIdFromStorage ==
                                        widget.occasionModel.personId
                                    ? state is UpdateOccasionLoadingState
                                        ? Center(child: const CircularProgressIndicator())
                                        : GestureDetector(
                                            onTap: () async {
                                              if (UserDataFromStorage
                                                      .uIdFromStorage ==
                                                  widget
                                                      .occasionModel.personId) {
                                                debugPrint("=== SAVE BUTTON PRESSED ===");
                                                debugPrint("Current giftWithPackage: ${cubit.giftWithPackage}");
                                                debugPrint("Current giftWithPackageType: ${cubit.giftWithPackageType}");
                                                debugPrint("Current selectedGiftPackageImage: '${cubit.selectedGiftPackageImage}'");
                                                
                                                cubit.updateOccasion(
                                                  occasionId: widget
                                                      .occasionModel.occasionId,
                                                );
                                              } else {
                                                return;
                                              }
                                            },
                                            child: Container(
                                              height: mediaQuery.height * 0.06,
                                              width: mediaQuery.width,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    ColorManager.primaryBlue,
                                                    ColorManager.primaryBlue
                                                        .withOpacity(0.8)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: ColorManager
                                                        .primaryBlue
                                                        .withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .translate('edit')
                                                      .toString(),
                                                  style: TextStyles
                                                      .textStyle18Bold
                                                      .copyWith(
                                                          color: ColorManager
                                                              .white),
                                                ),
                                              ),
                                            ),
                                          )
                                    : SizedBox(),
                                SizedBox(height: SizeConfig.height * 0.02),
                                UserDataFromStorage.uIdFromStorage ==
                                    widget.occasionModel.personId? InkWell(
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .unfocus(); // Dismiss the keyboard if open

                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .translate('occasionClosed')
                                                  .toString()),
                                          content: Text(AppLocalizations.of(
                                                  context)!
                                              .translate('closeOccasionMessage')
                                              .toString()),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .translate('confirmClosure')
                                                      .toString()),
                                              onPressed: () async {
                                                Navigator.of(context).pop(); // Close the dialog first
                                                await cubit.disableOccasion(
                                                    occasionId:
                                                    widget.occasionModel.occasionId.toString(),
                                                  context: context,
                                                );
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .translate('cancel')
                                                      .toString()),
                                              onPressed: () async {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog first
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: mediaQuery.height * 0.06,
                                    width: mediaQuery.width,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          ColorManager.primaryBlue,
                                          ColorManager.primaryBlue
                                              .withOpacity(0.8)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorManager.primaryBlue
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('closeOccasion')
                                            .toString(),
                                        style:
                                            TextStyles.textStyle18Bold.copyWith(
                                          color: ColorManager.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ) : SizedBox(),
                                SizedBox(height: SizeConfig.height * 0.03),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildSectionCard(BuildContext context,
    {required Widget child, required Color color}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      padding: EdgeInsets.all(SizeConfig.height * 0.02),
      decoration: BoxDecoration(
        color: color,
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
                colors: [
                  ColorManager.primaryBlue,
                  ColorManager.primaryBlue.withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isActive
            ? ColorManager.primaryBlue
            : ColorManager.gray.withOpacity(0.5),
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
          style: TextStyles.textStyle16Bold.copyWith(
              color: isActive ? ColorManager.white : ColorManager.black),
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
  
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: mediaQuery.height * 0.12,
      width: mediaQuery.width * 0.4,
      decoration: BoxDecoration(
        color: isSelected ? ColorManager.primaryBlue.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? ColorManager.primaryBlue : ColorManager.gray.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Package Image
          Container(
            height: mediaQuery.height * 0.06,
            width: mediaQuery.height * 0.06,
            decoration: BoxDecoration(
              color: ColorManager.gray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.primaryBlue,
                    strokeWidth: 2,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.card_giftcard,
                  color: ColorManager.primaryBlue,
                  size: mediaQuery.height * 0.03,
                ),
              ),
            ),
          ),
          SizedBox(height: mediaQuery.height * 0.01),
          // Price
          Text(
            "$price ${AppLocalizations.of(context)!.translate('rsa').toString()}",
            textAlign: TextAlign.center,
            style: TextStyles.textStyle12Bold.copyWith(
              color: isSelected ? ColorManager.primaryBlue : ColorManager.black,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPackageSelectionRow(BuildContext context, OccasionCubit cubit, Size mediaQuery) {
  // Check if it's a gift type or money type
  bool isGiftType = cubit.giftType == 'هدية';
  
  if (isGiftType) {
    // Use gift package lists
    return cubit.giftPackageListPrice.isNotEmpty && cubit.giftPackageListImage.isNotEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (cubit.giftPackageListPrice.length > 0)
                _buildPackageOption(
                  context,
                  price: cubit.giftPackageListPrice[0].toString(),
                  imageUrl: cubit.giftPackageListImage.length > 0 
                      ? cubit.giftPackageListImage[0].toString() 
                      : '',
                  isSelected: cubit.giftWithPackage && cubit.giftWithPackageType == int.parse(cubit.giftPackageListPrice[0].toString()),
                  onTap: () {
                    debugPrint("=== GIFT PACKAGE 0 SELECTED ===");
                    debugPrint("Price: ${cubit.giftPackageListPrice[0].toString()}");
                    debugPrint("Image: ${cubit.giftPackageListImage.length > 0 ? cubit.giftPackageListImage[0].toString() : ''}");
                    debugPrint("Before switch - giftWithPackageType: ${cubit.giftWithPackageType}");
                    // First enable packaging, then set the package type
                    cubit.switchGiftWithPackage(true);
                    cubit.switchGiftWithPackageType(
                      int.parse(cubit.giftPackageListPrice[0].toString()),
                      cubit.giftPackageListImage.length > 0 
                          ? cubit.giftPackageListImage[0].toString() 
                          : '',
                    );
                    debugPrint("After switch - giftWithPackageType: ${cubit.giftWithPackageType}");
                  },
                ),
              if (cubit.giftPackageListPrice.length > 1) ...[
                SizedBox(width: mediaQuery.width * 0.05),
                _buildPackageOption(
                  context,
                  price: cubit.giftPackageListPrice[1].toString(),
                  imageUrl: cubit.giftPackageListImage.length > 1 
                      ? cubit.giftPackageListImage[1].toString() 
                      : '',
                  isSelected: cubit.giftWithPackage && cubit.giftWithPackageType == int.parse(cubit.giftPackageListPrice[1].toString()),
                  onTap: () {
                    debugPrint("=== GIFT PACKAGE 1 SELECTED ===");
                    debugPrint("Price: ${cubit.giftPackageListPrice[1].toString()}");
                    debugPrint("Image: ${cubit.giftPackageListImage.length > 1 ? cubit.giftPackageListImage[1].toString() : ''}");
                    debugPrint("Before switch - giftWithPackageType: ${cubit.giftWithPackageType}");
                    // First enable packaging, then set the package type
                    cubit.switchGiftWithPackage(true);
                    cubit.switchGiftWithPackageType(
                      int.parse(cubit.giftPackageListPrice[1].toString()),
                      cubit.giftPackageListImage.length > 1 
                          ? cubit.giftPackageListImage[1].toString() 
                          : '',
                    );
                    debugPrint("After switch - giftWithPackageType: ${cubit.giftWithPackageType}");
                  },
                ),
              ],
            ],
          )
        : Center(
            child: Text(
              'Loading gift package options...',
              style: TextStyles.textStyle12Regular.copyWith(
                color: ColorManager.gray,
              ),
            ),
          );
  } else {
    // Use money package lists
    return cubit.moneyPackageListPrice.isNotEmpty && cubit.moneyPackageListImage.isNotEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (cubit.moneyPackageListPrice.length > 0)
                _buildPackageOption(
                  context,
                  price: cubit.moneyPackageListPrice[0].toString(),
                  imageUrl: cubit.moneyPackageListImage.length > 0 
                      ? cubit.moneyPackageListImage[0].toString() 
                      : '',
                  isSelected: cubit.giftWithPackage && cubit.moneyWithPackageType == int.parse(cubit.moneyPackageListPrice[0].toString()),
                  onTap: () {
                    debugPrint("=== MONEY PACKAGE 0 SELECTED ===");
                    debugPrint("Price: ${cubit.moneyPackageListPrice[0].toString()}");
                    debugPrint("Image: ${cubit.moneyPackageListImage.length > 0 ? cubit.moneyPackageListImage[0].toString() : ''}");
                    debugPrint("Before switch - moneyWithPackageType: ${cubit.moneyWithPackageType}");
                    // First enable packaging, then set the package type
                    cubit.switchGiftWithPackage(true);
                    cubit.switchMoneyWithPackageType(
                      int.parse(cubit.moneyPackageListPrice[0].toString()),
                      cubit.moneyPackageListImage.length > 0 
                          ? cubit.moneyPackageListImage[0].toString() 
                          : '',
                    );
                    debugPrint("After switch - moneyWithPackageType: ${cubit.moneyWithPackageType}");
                  },
                ),
              if (cubit.moneyPackageListPrice.length > 1) ...[
                SizedBox(width: mediaQuery.width * 0.05),
                _buildPackageOption(
                  context,
                  price: cubit.moneyPackageListPrice[1].toString(),
                  imageUrl: cubit.moneyPackageListImage.length > 1 
                      ? cubit.moneyPackageListImage[1].toString() 
                      : '',
                  isSelected: cubit.giftWithPackage && cubit.moneyWithPackageType == int.parse(cubit.moneyPackageListPrice[1].toString()),
                  onTap: () {
                    debugPrint("=== MONEY PACKAGE 1 SELECTED ===");
                    debugPrint("Price: ${cubit.moneyPackageListPrice[1].toString()}");
                    debugPrint("Image: ${cubit.moneyPackageListImage.length > 1 ? cubit.moneyPackageListImage[1].toString() : ''}");
                    debugPrint("Before switch - moneyWithPackageType: ${cubit.moneyWithPackageType}");
                    // First enable packaging, then set the package type
                    cubit.switchGiftWithPackage(true);
                    cubit.switchMoneyWithPackageType(
                      int.parse(cubit.moneyPackageListPrice[1].toString()),
                      cubit.moneyPackageListImage.length > 1 
                          ? cubit.moneyPackageListImage[1].toString() 
                          : '',
                    );
                    debugPrint("After switch - moneyWithPackageType: ${cubit.moneyWithPackageType}");
                  },
                ),
              ],
            ],
          )
        : Center(
            child: Text(
              'Loading money package options...',
              style: TextStyles.textStyle12Regular.copyWith(
                color: ColorManager.gray,
              ),
            ),
          );
  }
}
