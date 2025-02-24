import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../_core/component/card/custome_shadow_cotainner.dart';
import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';

class CardFlightInformation extends StatelessWidget {
  final String date;
  final String time;
  final String departureCity;
  final String arrivalCity;
  final String plane;
  final String seatClass;
  final String passenger;

  const CardFlightInformation({
    Key? key,
    required this.date,
    required this.time,
    required this.departureCity,
    required this.arrivalCity,
    required this.plane,
    required this.seatClass,
    required this.passenger,
  });

  @override
  Widget build(BuildContext context) {
    return CustomeShadowCotainner(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/images/citilink.svg', width: 40.w, height: 10.h),
          SizedBox(height: 10.h),
          Row(
            children: [
              TypographyStyles.small(
                date,
                color: GrayColors.gray600,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(width: 10.w),
              CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
              SizedBox(width: 10.w),
              TypographyStyles.small(
                time,
                color: GrayColors.gray600,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              TypographyStyles.body(departureCity, color: GrayColors.gray800, letterSpacing: 0.2),
              SizedBox(width: 10.w),
              // SvgPicture.asset('assets/icons/ic_plane_right_filled.svg'),
              CustomeIcons.PlaneRightFilled(color: PrimaryColors.primary800),
              SizedBox(width: 10.w),
              TypographyStyles.body(arrivalCity, color: GrayColors.gray800, letterSpacing: 0.2)
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              TypographyStyles.small(
                plane,
                color: GrayColors.gray600,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(width: 10.w),
              CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
              SizedBox(width: 10.w),
              TypographyStyles.small(
                seatClass,
                color: GrayColors.gray600,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          TypographyStyles.small(
            '$passenger Dewasa',
            color: GrayColors.gray600,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          )
        ],
      ),
    );
  }
}
