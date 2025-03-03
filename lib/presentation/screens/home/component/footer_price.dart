import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/card/custome_shadow_cotainner.dart';
import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';

class FooterPrice extends StatelessWidget {
  final String price;
  final String labelText;
  final String labelButton;
  final Widget? iconButton;
  final VoidCallback onTap;

  const FooterPrice({
    Key? key,
    required this.price,
    required this.labelText,
    required this.labelButton,
    this.iconButton,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomeShadowCotainner(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: "Total ${labelText}\n",
              style: TextStyle(
                fontFamily: 'DMSans',
                color: GrayColors.gray800,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                height: 1.8.h,
              ),
              children: [
                TextSpan(
                  text: "Rp ${price}",
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: PrimaryColors.primary800,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                )
              ],
            ),
          ),
          ZoomTapAnimation(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: PrimaryColors.primary800,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: iconButton != null
                    ? Row(
                        children: [
                          iconButton!,
                          SizedBox(width: 10.w),
                          TypographyStyles.body(labelButton, color: Colors.white)
                        ],
                      )
                    : TypographyStyles.body(labelButton, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
