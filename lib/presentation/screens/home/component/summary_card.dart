import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../_core/component/card/custome_shadow_cotainner.dart';
import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';

class SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Widget icon;

  const SummaryCard({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomeShadowCotainner(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: PrimaryColors.primary50,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: icon,
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: TypographyStyles.h6(
                value,
                color: GrayColors.gray800,
                overflow: TextOverflow.ellipsis,
                maxlines: 1,
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: TypographyStyles.caption(
                label,
                fontWeight: FontWeight.w400,
                color: GrayColors.gray500,
                overflow: TextOverflow.ellipsis,
                maxlines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
