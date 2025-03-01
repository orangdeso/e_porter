import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../_core/constants/colors.dart';

class CardIndicator extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? boxColor;
  final Border? border;

  const CardIndicator({
    Key? key,
    required this.text,
    this.textColor,
    this.boxColor,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 18.w,
          height: 18.h,
          decoration: BoxDecoration(
            border: border ?? Border(),
            borderRadius: BorderRadius.circular(4.r),
            color: boxColor ?? Colors.white,
          ),
        ),
        SizedBox(width: 16.w),
        TypographyStyles.small(text, color: textColor ?? GrayColors.gray800, fontWeight: FontWeight.w400)
      ],
    );
  }
}
