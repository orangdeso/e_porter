// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/card/custome_shadow_cotainner.dart';
import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';

class CardServicePorter extends StatelessWidget {
  final String text;
  final Widget icons;
  final VoidCallback? onTap;

  const CardServicePorter({
    Key? key,
    required this.text,
    required this.icons,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ZoomTapAnimation(
        child: GestureDetector(
          onTap: onTap,
          child: CustomeShadowCotainner(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: PrimaryColors.primary800,
                  child: icons,
                ),
                SizedBox(height: 20.h),
                TypographyStyles.body(text, color: GrayColors.gray800),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    TypographyStyles.caption("Detail", color: GrayColors.gray600, fontWeight: FontWeight.w400),
                    SizedBox(width: 10.h),
                    SvgPicture.asset('assets/icons/ic_right.svg', color: GrayColors.gray600, width: 14.w, height: 14.h)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
