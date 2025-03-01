import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../_core/component/card/custome_shadow_cotainner.dart';
import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';

class CardBoardingPass extends StatelessWidget {
  const CardBoardingPass({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomeShadowCotainner(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: GrayColors.gray500,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TypographyStyles.body('Kode Booking', color: Colors.white, fontWeight: FontWeight.w400),
                    SizedBox(width: 20.w),
                    TypographyStyles.body('I2L8JRL', color: Colors.white),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
                  child: TypographyStyles.caption('Keberangkatan', color: GrayColors.gray800),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
