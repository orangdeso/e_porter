// ignore_for_file: deprecated_member_use

import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputForm extends StatefulWidget {
  final String hintText;
  final String svgIconPath;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final bool enabled;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const InputForm({
    Key? key,
    required this.hintText,
    required this.svgIconPath,
    this.controller,
    this.validator,
    this.textInputType = TextInputType.text,
    this.inputFormatters,
    this.suffixIcon,
    this.enabled = true,
    this.onTap,
    this.backgroundColor = GrayColors.gray50,
  }) : super(key: key);

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    bool hasValidValue = widget.controller?.text.isNotEmpty == true &&
        widget.controller?.text != 'dd/mm/yyyy' &&
        widget.controller?.text != widget.hintText;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          enabled: widget.enabled,
          keyboardType: widget.textInputType,
          inputFormatters:
              widget.inputFormatters ?? <TextInputFormatter>[FilteringTextInputFormatter.singleLineFormatter],
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 16.sp,
            fontWeight: (widget.enabled && hasValidValue) ? FontWeight.w500 : FontWeight.w500,
            color: hasValidValue ? GrayColors.gray800 : GrayColors.gray800,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: GrayColors.gray500,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
              child: SvgPicture.asset(
                widget.svgIconPath,
                color: GrayColors.gray500,
              ),
            ),
            suffixIcon: widget.suffixIcon != null
                ? Padding(padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w), child: widget.suffixIcon)
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                width: 1.w,
                color: GrayColors.gray200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                width: 2.w,
                color: PrimaryColors.primary800,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                width: 1.w,
                color: GrayColors.gray200,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
