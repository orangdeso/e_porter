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

  const InputForm({
    Key? key,
    required this.hintText,
    required this.svgIconPath,
    this.controller,
    this.validator,
    this.textInputType = TextInputType.text,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GrayColors.gray50,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.textInputType,
        inputFormatters: widget.inputFormatters ??
            <TextInputFormatter>[
              FilteringTextInputFormatter.singleLineFormatter
            ],
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: GrayColors.gray600,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
            child: SvgPicture.asset(
              widget.svgIconPath,
              color: GrayColors.gray500,
            ),
          ),
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
              width: 1.w,
              color: GrayColors.gray200,
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
    );
  }
}
