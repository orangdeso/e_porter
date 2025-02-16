import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/typography.dart';

class ButtonListTile extends StatelessWidget {
  final String titleText;
  final String subTitle;
  final VoidCallback onTab;
  final String imageAssets;
  final String? svgIcon;
  final Color backroundColor;
  final Color strokeColor;

  const ButtonListTile({
    super.key,
    required this.titleText,
    required this.subTitle,
    required this.onTab,
    required this.imageAssets,
    this.svgIcon,
    required this.backroundColor,
    required this.strokeColor,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      child: Container(
        decoration: BoxDecoration(
            color: backroundColor,
            border: Border.all(
              color: strokeColor,
              width: 1.w,
            ),
            borderRadius: BorderRadius.circular(10.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
          child: ListTile(
            onTap: onTab,
            leading: CircleAvatar(
              backgroundColor: PrimaryColors.primary800,
              radius: 22,
              child: SvgPicture.asset(
                imageAssets,
                width: 24.w,
                height: 24.w,
              ),
            ),
            title: TypographyStyles.body(
              titleText,
              color: GrayColors.gray800,
              overflow: TextOverflow.ellipsis,
              maxlines: 1,
            ),
            subtitle: TypographyStyles.small(
              subTitle,
              color: GrayColors.gray600,
              overflow: TextOverflow.ellipsis,
              maxlines: 1,
              fontWeight: FontWeight.w400,
            ),
            trailing: svgIcon != null
                ? SvgPicture.asset(
                    svgIcon!,
                    width: 18.w,
                    height: 18.h,
                  )
                : SvgPicture.asset(
                    'assets/icons/ic_more _than.svg',
                    width: 18.w,
                    height: 18.h,
                  ),
          ),
        ),
      ),
    );
  }
}
