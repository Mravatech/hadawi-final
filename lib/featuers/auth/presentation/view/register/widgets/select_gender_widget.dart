import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/featuers/edit_personal_info/view/controller/edit_profile_states.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';

import '../../../../../edit_personal_info/view/controller/edit_profile_cubit.dart';

class SelectGenderWidget extends StatelessWidget {
  final bool isFromRegister;
  const SelectGenderWidget ({super.key, required this.isFromRegister});

  @override
  Widget build(BuildContext context) {
    return isFromRegister==true?
    BlocBuilder<AuthCubit,AuthStates>(
      builder: (context, state) {
        var cubit = context.read<AuthCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.translate('gender').toString(),
              style: TextStyles.textStyle18Bold.copyWith(
              color: ColorManager.black,
              fontSize: MediaQuery.sizeOf(context).height*0.02
            ),),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text(AppLocalizations.of(context)!.translate('male').toString(),
                      style: TextStyles.textStyle18Medium,),
                    activeColor: ColorManager.primaryBlue,
                    value: 'Male',
                    groupValue: cubit.genderValue,
                    onChanged: (String? value) {
                      cubit.changeGenderValue(value);
                    },
                  ),
                ),

                Expanded(
                  child: RadioListTile(
                    value: 'Female',
                    title: Text(AppLocalizations.of(context)!.translate('female').toString(),
                      style: TextStyles.textStyle18Medium,),
                      groupValue: cubit.genderValue,
                      onChanged: (String? value) {
                        cubit.changeGenderValue(value);
                      },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ) :
    BlocBuilder<EditProfileCubit,EditProfileStates>(
      builder: (context, state) {
        var cubit = context.read<EditProfileCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                AppLocalizations.of(context)!
                    .translate('gender')
                    .toString(),
                style: TextStyles.textStyle18Bold
                    .copyWith(
                  color: ColorManager.white,
                )),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text(AppLocalizations.of(context)!.translate('male').toString(),
                      style: TextStyles.textStyle18Medium.copyWith(
                        color: Color(0xFF8B7BA8)
                      ),),
                    value: 'Male',
                    groupValue: cubit.genderValue,
                    onChanged: (String? value) {
                      cubit.changeGenderValue(value);
                    },
                  ),
                ),

                Expanded(
                  child: RadioListTile(
                    value: 'Female',
                    title: Text(AppLocalizations.of(context)!.translate('female').toString(),
                      style: TextStyles.textStyle18Medium.copyWith(
                        color: Color(0xFF8B7BA8)
                      ),),
                    groupValue: cubit.genderValue,
                    onChanged: (String? value) {
                      cubit.changeGenderValue(value);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
