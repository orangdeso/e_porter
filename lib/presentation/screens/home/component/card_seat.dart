import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/constants/colors.dart';

class CardSeat extends StatelessWidget {
  final bool isTaken;
  final bool isSelected;
  final String seatLabel;
  final VoidCallback? onTap;

  const CardSeat({
    Key? key,
    required this.isTaken,
    required this.isSelected,
    required this.seatLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Border? border;
    if (isTaken) {
      backgroundColor = const Color(0xFFD9D9D9);
    } else if (isSelected) {
      backgroundColor = PrimaryColors.primary800;
    } else {
      backgroundColor = Colors.white;
      border = Border.all(width: 1.w, color: PrimaryColors.primary800);
    }

    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            border: border,
            color: backgroundColor,
          ),
          child: Center(
            child: TypographyStyles.body(seatLabel, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
