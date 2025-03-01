import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CardSeat extends StatelessWidget {
  // final VoidCallback onTap;

  const CardSeat({
    Key? key,
    // required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ZoomTapAnimation(
          child: GestureDetector(
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
