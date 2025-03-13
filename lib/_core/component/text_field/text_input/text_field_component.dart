import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/colors.dart';

class TextFieldComponent extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validators;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldComponent({
    this.controller,
    required this.hintText,
    this.validators,
    this.textInputType,
    this.inputFormatters
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r)),
      child: TextFormField(
        controller: controller,
        validator: validators,
        keyboardType: textInputType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          prefix: Padding(padding: EdgeInsets.symmetric(horizontal: 10.w)),
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'DMsans',
            fontSize: 16.sp,
            color: GrayColors.gray600,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(width: 1, color: GrayColors.gray200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(width: 1, color: GrayColors.gray200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(width: 1.5.w, color: PrimaryColors.primary800),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }
}
