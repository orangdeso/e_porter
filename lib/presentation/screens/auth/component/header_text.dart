import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';

class HeaderText extends StatelessWidget {
  final String firstText;
  final String secondText;

  const HeaderText({
    super.key,
    required this.firstText,
    required this.secondText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TypographyStyles.h3(
          firstText,
          color: GrayColors.gray800,
          maxlines: 2,
        ),
        SizedBox(height: 32.h),
        TypographyStyles.h6(
          secondText,
          color: GrayColors.gray600,
          fontWeight: FontWeight.w500,
          maxlines: 3,
        ),
      ],
    );
  }
}
