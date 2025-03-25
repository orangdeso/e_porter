import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';

class PorterRadio extends StatelessWidget {
  final String title;
  final String subTitle;
  final String price;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onTap;

  const PorterRadio({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.price,
    required this.value,
    required this.groupValue,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onTap,
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
                  SizedBox(height: 2.h),
                  TypographyStyles.caption(
                    subTitle,
                    color: GrayColors.gray500,
                    fontWeight: FontWeight.w400,
                    maxlines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),
                  TypographyStyles.caption(price, color: PrimaryColors.primary800)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
