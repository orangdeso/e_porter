import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../_core/constants/typography.dart';

class FlightSelector extends StatelessWidget {
  final String label;
  final String hintText;
  final Widget svgIconPath;
  final VoidCallback? onTap;

  const FlightSelector({
    Key? key,
    required this.label,
    required this.hintText,
    required this.svgIconPath,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            strokeAlign: 1,
            color: GrayColors.gray200,
          ),
        ),
        child: Row(
          children: [
            svgIconPath,
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TypographyStyles.small(
                  label,
                  color: GrayColors.gray500,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 4.h),
                TypographyStyles.body(
                  hintText,
                  color: GrayColors.gray800,
                  fontWeight: FontWeight.w500,
                  maxlines: 1,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
