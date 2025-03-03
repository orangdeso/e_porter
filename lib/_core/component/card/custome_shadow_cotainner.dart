import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomeShadowCotainner extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double borderRadius;
  final BoxBorder? border;
  final EdgeInsets? padding;
  final double? height;

  const CustomeShadowCotainner({
    Key? key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderRadius = 10.0,
    this.border,
    this.padding,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ??
            Border.all(
              strokeAlign: 1,
              color: GrayColors.gray100,
            ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            offset: const Offset(0, 4),
            blurRadius: 14,
            spreadRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}
