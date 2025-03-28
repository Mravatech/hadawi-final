import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';

class RememberMeButton extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const RememberMeButton({
    super.key,
    this.initialValue = false,
    this.onChanged,
  });

  @override
  State<RememberMeButton> createState() => _RememberMeButtonState();
}

class _RememberMeButtonState extends State<RememberMeButton> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _isChecked,
          activeColor: ColorManager.primaryBlue,
          onChanged: (bool? value) {
            if (value != null) {
              setState(() {
                _isChecked = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            }
          },
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
              if (widget.onChanged != null) {
                widget.onChanged!(_isChecked);
              }
            });
          },
          child: Text(
            AppLocalizations.of(context)!.translate('rememberMe').toString(),
            style: TextStyles.textStyle18Bold.copyWith(
                color: ColorManager.darkGrey,
                fontSize: MediaQuery.sizeOf(context).height * 0.018),
          ),
        ),
      ],
    );
  }
}
