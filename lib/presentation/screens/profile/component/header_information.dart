import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderInformation extends StatelessWidget {
  final String title;

  const HeaderInformation({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.info_outline_rounded,
          color: GrayColors.gray500,
          size: 24.sp,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: TypographyStyles.caption(
              title,
              color: GrayColors.gray500,
              maxlines: 6,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }
}
