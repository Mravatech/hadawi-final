import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/constants/app_constants.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/controller/edit_profile_cubit.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/controller/edit_profile_states.dart';
import 'package:hadawi_app/featuers/splash/preentation/view/widgets/logo_image.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_app_bar_widget.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/default_text_field.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../auth/presentation/view/register/widgets/country_code_widget.dart';
import '../../../auth/presentation/view/register/widgets/select_gender_widget.dart';
import '../../../home_layout/presentation/controller/home_cubit.dart';

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
            setState(() {
              context.read<HomeCubit>().currentIndex = 2;
            });
            Navigator.pop(context);
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
          if (state is CheckPhoneSuccessState) {
            if (context.read<EditProfileCubit>().isUsed == false) {
              Navigator.pop(context);
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
                              enabled: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!.translate('emailHint').toString();
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
                              context.read<EditProfileCubit>().getUserInfo(
                                    date: dateController.text,
                                    phone: phoneController.text,
                                    context: context,
                                    gender: context.read<EditProfileCubit>().genderValue,
                                    name: nameController.text,
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
