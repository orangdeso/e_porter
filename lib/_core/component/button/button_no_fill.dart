import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/typography.dart';

class ButtonNoFill extends StatelessWidget {
  final String text;
  final Color? textColor;
  final VoidCallback? onTap;

  const ButtonNoFill({
    Key? key,
    required this.text,
    required this.textColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/ic_left.svg'),
                SizedBox(width: 16.w),
                TypographyStyles.body(
                  text,
                  color: textColor,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
