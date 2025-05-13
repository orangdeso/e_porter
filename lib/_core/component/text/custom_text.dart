import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText {
  CustomText._();

  static Widget textPadding8(
    String text, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: TypographyStyles.body(
        text,
        color: color ?? GrayColors.gray800,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
