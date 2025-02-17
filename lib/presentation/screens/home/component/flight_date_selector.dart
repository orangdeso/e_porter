import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../_core/constants/typography.dart';

class FlightDateSelector extends StatelessWidget {
  final String label;
  final String valueText;
  final String svgIconPath;
  final VoidCallback? onTap;

  const FlightDateSelector({
    Key? key,
    required this.label,
    required this.valueText,
    required this.svgIconPath,
    required this.onTap,
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
            SvgPicture.asset(svgIconPath),
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
                  valueText,
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
