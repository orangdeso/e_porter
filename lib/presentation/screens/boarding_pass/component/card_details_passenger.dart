import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardDetailsPassenger extends StatelessWidget {
  final String name;
  final String typeId;
  final String noId;
  final String seatClass;
  final String numberSeat;

  const CardDetailsPassenger({
    Key? key,
    required this.name,
    required this.typeId,
    required this.noId,
    required this.seatClass,
    required this.numberSeat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TypographyStyles.body(name, color: GrayColors.gray800),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: PrimaryColors.primary100,
                borderRadius: BorderRadius.circular(35.r),
              ),
              child: TypographyStyles.small("Dewasa", color: PrimaryColors.primary800, fontWeight: FontWeight.w500),
            )
          ],
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TypographyStyles.caption("${typeId} - ${noId}", color: GrayColors.gray500, fontWeight: FontWeight.w400),
            TypographyStyles.caption("${seatClass} / ${numberSeat}", color: GrayColors.gray500, fontWeight: FontWeight.w400),
          ],
        ),
        SizedBox(height: 20.h),
        Divider(thickness: 1, color: GrayColors.gray200)
      ],
    );
  }
}
