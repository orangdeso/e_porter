import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../_core/constants/typography.dart';

class FlightClassRadio extends StatelessWidget {
  final String title;
  final String subTitle;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const FlightClassRadio({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: GrayColors.gray50,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            strokeAlign: 1,
            color: GrayColors.gray200,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: PrimaryColors.primary800,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypographyStyles.body(
                    title,
                    color: GrayColors.gray800,
                    maxlines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  TypographyStyles.caption(
                    subTitle,
                    color: GrayColors.gray500,
                    fontWeight: FontWeight.w400,
                    maxlines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
