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
            Row(
              children: [
                icon,
                SizedBox(width: 16.w),
                Expanded(
                  child: TypographyStyles.caption(
                    label,
                    color: GrayColors.gray600,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                    maxlines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            TypographyStyles.body(
              value,
              color: GrayColors.gray800,
              overflow: TextOverflow.ellipsis,
              maxlines: 1,
            )
          ],
        ),
      ),
    );
  }
}
