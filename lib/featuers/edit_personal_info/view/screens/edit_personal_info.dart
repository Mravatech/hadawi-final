import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/controller/edit_profile_cubit.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/controller/edit_profile_states.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../auth/presentation/view/register/widgets/country_code_widget.dart';
import '../../../auth/presentation/view/register/widgets/select_gender_widget.dart';
import '../../../home_layout/presentation/controller/home_cubit.dart';
import '../../../home_layout/presentation/view/home_layout/home_layout.dart';
import '../../../../utiles/helper/material_navigation.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = UserDataFromStorage.userNameFromStorage;
    emailController.text = UserDataFromStorage.emailFromStorage;
    phoneController.text = UserDataFromStorage.phoneNumberFromStorage;
    dateController.text = UserDataFromStorage.brithDateFromStorage;
    context
        .read<EditProfileCubit>()
        .genderValue = UserDataFromStorage.genderFromStorage;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            // Navigate to HomeLayout with Profile tab selected
            context.read<HomeCubit>().changeIndex(index: 2);
            customPushAndRemoveUntil(context, HomeLayout());
          },
          icon: Icon(Icons.arrow_back, color: Color(0xFF8B7BA8)),
        ),
        title: Text(
          AppLocalizations.of(context)!.translate('info').toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8B7BA8),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(image: AssetImage(AssetsManager.logoWithoutBackground)),
          ),
        ],
      ),
      body: BlocConsumer<EditProfileCubit, EditProfileStates>(
        listener: (context, state) {
          if (state is EditProfileErrorState) {
            customToast(title: state.message, color: ColorManager.error);
          }
          if (state is EditProfileSuccessState) {
            // Navigate to HomeLayout with Profile tab selected after successful update
            context.read<HomeCubit>().changeIndex(index: 2);
            customPushAndRemoveUntil(context, HomeLayout());
          }
          if (state is CheckPhoneSuccessState) {
            if (context.read<EditProfileCubit>().isUsed == false) {
              // Navigate to HomeLayout with Profile tab selected after successful update
              context.read<HomeCubit>().changeIndex(index: 2);
              customPushAndRemoveUntil(context, HomeLayout());
            }
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is EditProfileLoadingState || state is CheckPhoneLoadingState,
            progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B7BA8)),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Profile Header
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
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
                            _buildFormField(
                              context,
                              title: AppLocalizations.of(context)!.translate('fullName').toString(),
                              controller: nameController,
                              hint: AppLocalizations.of(context)!.translate('fullNameHint').toString(),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!.translate('fullNameHint').toString();
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            _buildFormField(
                              context,
                              title: AppLocalizations.of(context)!.translate('email').toString(),
                              controller: emailController,
                              hint: AppLocalizations.of(context)!.translate('emailHint').toString(),
                              enabled: UserDataFromStorage.emailFromStorage.isEmpty,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!.translate('emailHint').toString();
                                }
                                // Add email format validation
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            _buildFormField(
                              context,
                              title: AppLocalizations.of(context)!.translate('phone').toString(),
                              controller: phoneController,
                              hint: AppLocalizations.of(context)!.translate('loginPhoneHint').toString(),
                              prefix: CountryCodeWidget(color: Colors.white),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!.translate('loginPhoneHint').toString();
                                }
                                if (value.length != 9) {
                                  return AppLocalizations.of(context)!.translate('validatePhone').toString();
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              AppLocalizations.of(context)!.translate('brithHint').toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF8B7BA8),
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => showDatePicker(
                                context: context,
                                firstDate: DateTime(1920),
                                lastDate: DateTime.now(),
                                helpText: AppLocalizations.of(context)!.translate('brithHint').toString(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Color(0xFF8B7BA8),
                                        onPrimary: Colors.white,
                                        surface: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              ).then((value) => context.read<EditProfileCubit>().setBrithDate(
                                    brithDateController: dateController,
                                    brithDateValue: value!,
                                  )),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Color(0xFFE0E0E0)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        dateController.text.isEmpty
                                            ? AppLocalizations.of(context)!.translate('brithMessage').toString()
                                            : dateController.text,
                                        style: TextStyle(
                                          color: dateController.text.isEmpty ? Colors.grey : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.calendar_today, color: Color(0xFF8B7BA8)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            SelectGenderWidget(isFromRegister: false),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              // Check if email is empty and being updated
                              String? emailToUpdate;
                              if (UserDataFromStorage.emailFromStorage.isEmpty && 
                                  emailController.text.isNotEmpty) {
                                emailToUpdate = emailController.text;
                              }
                              
                              context.read<EditProfileCubit>().getUserInfo(
                                    date: dateController.text,
                                    phone: phoneController.text,
                                    context: context,
                                    gender: context.read<EditProfileCubit>().genderValue,
                                    name: nameController.text,
                                    email: emailToUpdate,
                                  );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8B7BA8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.translate('save').toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormField(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    required String hint,
    Widget? prefix,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF8B7BA8),
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: prefix,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF8B7BA8)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
        ),
      ],
    );
  }
}
