import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/data/models/occasion_model.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../generated/assets.dart';
import '../../../../../styles/colors/color_manager.dart';
import '../../../../../styles/size_config/app_size_config.dart';
import '../../../../../styles/text_styles/text_styles.dart';
import '../../../../../utiles/cashe_helper/cashe_helper.dart';
import '../../../../../utiles/localiztion/app_localization.dart';
import '../../../../../utiles/shared_preferences/shared_preference.dart';
import '../../../../../widgets/default_text_field.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../../auth/presentation/controller/auth_cubit.dart';

class EditOccasion extends StatefulWidget {
  final OccasionModel occasionModel;

  const EditOccasion({super.key, required this.occasionModel});

  @override
  State<EditOccasion> createState() => _EditOccasionState();
}

class _EditOccasionState extends State<EditOccasion> {
  @override
  void initState() {
    context.read<OccasionCubit>().nameController.text =
        widget.occasionModel.personName;
    context.read<OccasionCubit>().giftNameController.text =
        widget.occasionModel.giftName;
    context.read<OccasionCubit>().linkController.text =
        widget.occasionModel.giftLink;
    context.read<OccasionCubit>().moneyAmountController.text =
        widget.occasionModel.moneyGiftAmount.toString();
    context.read<OccasionCubit>().giftDeliveryStreetController.text =
        widget.occasionModel.district;
    context.read<OccasionCubit>().giftReceiverNumberController.text =
        widget.occasionModel.receiverPhone;
    context.read<OccasionCubit>().giftReceiverNameController.text =
        widget.occasionModel.receiverName;
    context.read<OccasionCubit>().moneyGiftMessageController.text =
        widget.occasionModel.giftCard;
    context.read<OccasionCubit>().giftDeliveryNoteController.text =
        widget.occasionModel.note;
    context.read<OccasionCubit>().dropdownOccasionType =  widget.occasionModel.type;
    context.read<OccasionCubit>().giftType=  widget.occasionModel.giftType;
    context.read<OccasionCubit>().moneyAmountController.text =  widget.occasionModel.giftPrice.toString();
    context.read<OccasionCubit>().dropdownCity = widget.occasionModel.city;
    context.read<OccasionCubit>().urls= widget.occasionModel.giftImage;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
          if(state is UpdateOccasionSuccessState ){
            if (widget.fromHome==true) {
              context.read<VisitorsCubit>().getOccasions().then(
                (value) {
                  customPushReplacement(context, HomeLayout());
                },
              );

            } else {
              context.read<OccasionsListCubit>().getClosedOccasionsList();
              context.read<OccasionsListCubit>().getMyOccasionsList();
              context.read<OccasionsListCubit>().getOthersOccasionsList();
              context.read<OccasionsListCubit>().getPastOccasionsList();
              customPushReplacement(context, AllOccasionsScreen());
            }


          }
        },
        builder: (context, state) {
          final cubit = context.read<OccasionCubit>();
          final mediaQuery = MediaQuery.sizeOf(context);

    return ModalProgressHUD(
      inAsyncCall: state is DisableOccasionLoadingState,
      progressIndicator: const LoadingAnimationWidget(),
      child: Padding(
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
                  color: ColorManager.gray,
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
                          value: widget.occasionModel.isPrivate,
                          onChanged: (value) {},
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
                /// person name
                _buildSectionCard(
                  color: ColorManager.white,
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
                        validator: (value) =>
                        value!.isEmpty ? AppLocalizations.of(context)!.translate('validatePersonName').toString() : null,
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
                            value: cubit.dropdownOccasionType.isEmpty ? widget.occasionModel.type : cubit.dropdownOccasionType,
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
                  color: ColorManager.gray,
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
                            isActive: widget.occasionModel.giftType == 'هدية',
                            onTap: () {
                              // cubit.giftType = 'هدية';
                              // UserDataFromStorage.giftType = cubit.giftType;
                              // cubit.switchGiftType();
                            },
                          ),
                          SizedBox(width: SizeConfig.width * 0.05),
                          _buildGiftTypeButton(
                            context,
                            title: AppLocalizations.of(context)!.translate('money').toString(),
                            isActive: widget.occasionModel.giftType == 'مبلغ مالي',
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

                /// gift section
                _buildSectionCard(
                  color: ColorManager.white,
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
                        validator: (value) =>
                        value!.trim().isEmpty ? AppLocalizations.of(context)!.translate('validateGiftName').toString() : null,
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
                            return AppLocalizations.of(context)!.translate('validateLink').toString();
                          }
                          final uri = Uri.tryParse(value);
                          if (uri == null || !(uri.isScheme('http') || uri.isScheme('https')) || uri.host.isEmpty || !uri.host.contains('.')) {
                            return AppLocalizations.of(context)!.translate('vaildLink').toString();
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
                              validator: (value) =>
                              value!.trim().isEmpty ? AppLocalizations.of(context)!.translate('validateGiftAmount').toString() : null,
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
                       Column(
                          children: [
                            SizedBox(height: SizeConfig.height * 0.02),
                            state is GetOccasionTaxesLoadingState
                                ? const LoadingAnimationWidget()
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildPackageOption(
                                  context,
                                  price: cubit.packageListPrice[0].toString(),
                                  imageUrl: cubit.packageListImage[0].toString(),
                                  isSelected: cubit.giftWithPackageType == int.parse(cubit.packageListPrice[0].toString()),
                                  onTap: () {
                                    // cubit.switchGiftWithPackageType(
                                    //   int.parse(cubit.packageListPrice[0].toString()),
                                    //   cubit.packageListImage[0].toString(),
                                    // );
                                  },
                                ),
                                _buildPackageOption(
                                  context,
                                  price: cubit.packageListPrice[1].toString(),
                                  imageUrl: cubit.packageListImage[1].toString(),
                                  isSelected: cubit.giftWithPackageType == int.parse(cubit.packageListPrice[1].toString()),
                                  onTap: () {
                                    // cubit.switchGiftWithPackageType(
                                    //   int.parse(cubit.packageListPrice[1].toString()),
                                    //   cubit.packageListImage[1].toString(),
                                    // );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      SizedBox(height: SizeConfig.height * 0.02),

                      Text(
                        AppLocalizations.of(context)!.translate('deliveryDetails').toString(),
                        style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                      ),
                      SizedBox(height: SizeConfig.height * 0.02),
                      _buildSectionCard(
                        color: ColorManager.white,
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
                                  value: cubit.dropdownCity.isEmpty ? widget.occasionModel.city : cubit.dropdownCity,
                                  hint: Text(AppLocalizations.of(context)!.translate('enterYourCity').toString()),
                                  icon: const Icon(Icons.keyboard_arrow_down, color: ColorManager.primaryBlue),
                                  elevation: 16,
                                  style: TextStyles.textStyle16Regular.copyWith(color: ColorManager.black),
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      cubit.dropdownCity = newValue!;
                                    });
                                  },
                                  items: context.read<AuthCubit>().allCity.map<DropdownMenuItem<String>>((dynamic value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: TextStyles.textStyle16Regular.copyWith(color: ColorManager.black)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: SizeConfig.height * 0.02),

                            Text(
                              AppLocalizations.of(context)!.translate('theDistrict').toString(),
                              style: TextStyles.textStyle18Bold.copyWith(color: ColorManager.black),
                            ),
                            SizedBox(height: SizeConfig.height * 0.01),
                            DefaultTextField(
                              controller: cubit.giftDeliveryStreetController,
                              hintText: AppLocalizations.of(context)!.translate('theDistrictHint').toString(),
                              validator: (value) =>
                              value!.isEmpty ? AppLocalizations.of(context)!.translate('validateTheDistrict').toString() : null,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              fillColor: ColorManager.gray.withOpacity(0.5),
                            ),
                            SizedBox(height: SizeConfig.height * 0.02),

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
                                  return AppLocalizations.of(context)!.translate('validateMoneyReceiverPhone').toString();
                                }
                                if (value.length != 10) {
                                  return AppLocalizations.of(context)!.translate('validatePhone2').toString();
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
                                  controller: cubit.moneyGiftMessageController,
                                  maxLines: 3,
                                  hintText: '',
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  fillColor: ColorManager.gray.withOpacity(0.5),
                                  validator: (value) =>null,
                                ),
                              ],
                            ),
                            SizedBox(height: SizeConfig.height * 0.02),

                            Column(
                              children: [
                                SizedBox(height: SizeConfig.height * 0.01),
                                DefaultTextField(
                                  controller: cubit.giftDeliveryNoteController,
                                  maxLines: 3,
                                  hintText: '',
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  fillColor: ColorManager.gray.withOpacity(0.5),
                                  validator: (value) =>null,
                                ),
                              ],
                            ),
                            SizedBox(height: SizeConfig.height * 0.03),

                            /// Continue Button
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  // if (forMeFormKey.currentState!.validate()) {
                                  //   if (cubit.dropdownOccasionType.isNotEmpty) {
                                  //     if ((cubit.images.isNotEmpty && cubit.isPresent) || !cubit.isPresent) {
                                  //       cubit.getTotalGiftPrice();
                                  //       customPushNavigator(context, OccasionSummary());
                                  //     } else {
                                  //       customToast(
                                  //         title: AppLocalizations.of(context)!.translate('validateImage').toString(),
                                  //         color: Colors.red,
                                  //       );
                                  //     }
                                  //   } else {
                                  //     customToast(
                                  //       title: AppLocalizations.of(context)!.translate('validateOccasionType').toString(),
                                  //       color: Colors.red,
                                  //     );
                                  //   }
                                  // }
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
                                      AppLocalizations.of(context)!.translate('edit').toString(),
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
  return InkWell(
    onTap: onTap,
    child: SizedBox(
      height: mediaQuery.height * 0.1,
      width: mediaQuery.height * 0.1,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorManager.primaryBlue.withOpacity(0.2)
                  : ColorManager.gray.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: ColorManager.primaryBlue, width: 2)
                  : null,
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
