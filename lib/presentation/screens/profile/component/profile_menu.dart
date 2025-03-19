// ignore_for_file: deprecated_member_use

import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ProfileMenu extends StatelessWidget {
  final String label;
  final String svgIcon;
  final VoidCallback? onTap;

  const ProfileMenu({
    Key? key,
    required this.label,
    required this.svgIcon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: PrimaryColors.primary800,
              child: SvgPicture.asset(svgIcon, color: Colors.white, width: 20.w, height: 20.h),
            ),
            SizedBox(width: 20.w),
            Expanded(child: TypographyStyles.body(label, color: GrayColors.gray800, fontWeight: FontWeight.w500)),
            CustomeIcons.MoreThanOutline(),
          ],
        ),
      ),
    );
  }
}
