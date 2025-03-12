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
  final String? servicePorter;
  final String passenger;

  const CardFlightInformation({
    Key? key,
    required this.date,
    required this.time,
    required this.departureCity,
    required this.arrivalCity,
    required this.plane,
    required this.seatClass,
    this.servicePorter,
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
              TypographyStyles.body(departureCity, color: GrayColors.gray800),
              SizedBox(width: 10.w),
              CustomeIcons.PlaneRightFilled(color: PrimaryColors.primary800),
              SizedBox(width: 10.w),
              TypographyStyles.body(arrivalCity, color: GrayColors.gray800)
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              TypographyStyles.small(plane, color: GrayColors.gray600, fontWeight: FontWeight.w400),
              _buildText(context, text: seatClass),
              servicePorter != null ? _buildText(context, text: servicePorter!) : SizedBox.shrink(),
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

  Widget _buildText(
    BuildContext context, {
    required String text,
  }) {
    return Row(
      children: [
        SizedBox(width: 10.w),
        CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
        SizedBox(width: 10.w),
        TypographyStyles.small(
          text,
          color: GrayColors.gray600,
          letterSpacing: 0.2,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
