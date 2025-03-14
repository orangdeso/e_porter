import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/typography.dart';

class ButtonOutline extends StatelessWidget {
  final String text;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool isLoading;
  final double? buttonWidth;
  final TextStyle? customTextStyle;
  final EdgeInsets? padding;

  const ButtonOutline({
    Key? key,
    required this.text,
    required this.textColor,
    this.onTap,
    this.isLoading = false,
    this.buttonWidth,
    this.customTextStyle,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth ?? double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.r),
          ),
          side: BorderSide(
            width: 2.w,
            color: PrimaryColors.primary800,
          ),
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(vertical: 14.h),
          child: isLoading ? _rowLoading() : _buildText(),
        ),
      ),
    );
  }

  Widget _buildText() {
    if (customTextStyle != null) {
      return Text(
        text,
        style: customTextStyle,
      );
    }

    return TypographyStyles.h6(
      text,
      color: textColor,
      letterSpacing: 1,
      fontWeight: FontWeight.bold,
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
