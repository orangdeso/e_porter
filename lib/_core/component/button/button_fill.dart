import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/typography.dart';

class ButtonFill extends StatelessWidget {
  final String text;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? backgroundColor;

  const ButtonFill({
    Key? key,
    required this.text,
    required this.textColor,
    this.onTap,
    this.isLoading = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isLoading ? GrayColors.gray400 : (backgroundColor ?? PrimaryColors.primary800),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: isLoading
                ? _rowLoading()
                : TypographyStyles.h6(
                    text,
                    color: textColor,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _rowLoading() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TypographyStyles.h6(
          'Loading...',
          color: Colors.white,
        ),
        SizedBox(width: 10.w),
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5.w,
          ),
        )
      ],
    );
  }
}
