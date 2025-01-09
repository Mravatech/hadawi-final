import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:toastification/toastification.dart';

ToastificationItem toastificationWidget(
    {
  required BuildContext context,
  required String title,
  required String body,
  required ToastificationType type,
}){ {
  return toastification.show(
    context: context,
    title: Text(title,style: TextStyles.textStyle18Bold.copyWith(
        color: ColorManager.primaryBlue,
        fontWeight: FontWeight.w300,
        fontSize: 15
    ),),
    description:  Text(body,style: TextStyles.textStyle18Bold.copyWith(
        color: ColorManager.primaryBlue,
        fontWeight: FontWeight.w300,
        fontSize: 15
    ),),
    borderRadius: BorderRadius.circular(15),
    type: type,
    style: ToastificationStyle.flatColored,
    autoCloseDuration: const Duration(seconds: 5),
    showProgressBar: false,
    alignment: Alignment.topCenter,
    closeButtonShowType: CloseButtonShowType.none,
    /// to make it transparent or not
  );

}
}