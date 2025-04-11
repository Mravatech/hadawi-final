import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';

class DefaultTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool withSuffix;
  final bool isPassword;
  bool viewPassword;
  final bool? enable;
  final IconData? suffixIcon;
  final Widget? prefix;
  final int? maxLines;
  final Color? fillColor;
  final void Function()? onTap;
  final ValueChanged<String>? onChanged;
  final String? initialValue; // ✅ إضافة initialValue

  DefaultTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    required this.keyboardType,
    required this.textInputAction,
    this.withSuffix = false,
    this.isPassword = false,
    this.onTap,
    this.onChanged,
    this.viewPassword = true,
    this.suffixIcon,
    this.prefix,
    this.enable = true,
    this.maxLines = 1,
    required this.fillColor,
    this.initialValue,
  });

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.controller.text.isEmpty) {
      widget.controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        onChanged:widget.onChanged ,
        onTap: widget.onTap,
        enabled: widget.enable,
        style: TextStyle(
          fontSize: MediaQuery.sizeOf(context).height * 0.02,
          color: ColorManager.black,
        ),
        decoration: InputDecoration(
          prefixIcon: widget.prefix,
          filled: true,
          fillColor: widget.fillColor,
          errorStyle: TextStyle(
            fontSize: MediaQuery.sizeOf(context).height * 0.014,
            color: ColorManager.error,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: MediaQuery.sizeOf(context).height * 0.016,
            color: ColorManager.black,
          ),
          suffixIcon: widget.withSuffix==true ?
          IconButton(
            onPressed: () {
              setState(() {
                widget.viewPassword = !widget.viewPassword;
              });
            },
            icon: widget.viewPassword == false
                ? const Icon(
              Icons.visibility_outlined,
              color: Colors.grey,
            )
                : const Icon(
              Icons.visibility_off_outlined,
              color: Colors.grey,
            ),
          ) :null,
          contentPadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).height*0.022,
              vertical: MediaQuery.sizeOf(context).height*0.01
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height*0.01),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height*0.01),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height*0.01),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorManager.error,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height*0.01),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide:  const BorderSide(
              color: ColorManager.gray,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height*0.01),
          ),
        ),
        controller: widget.controller,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        maxLines: widget.maxLines,
        obscureText: widget.isPassword?widget.viewPassword:false,
      ),
    );
  }
}
