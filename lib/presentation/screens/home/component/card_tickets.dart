import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CardTickets extends StatelessWidget {
  final String departureCity;
  final String date;
  final String arrivalCity;
  final String departureCode;
  final String arrivalCode;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String seatClass;
  final String price;
  final VoidCallback onTap;

  const CardTickets({
    Key? key,
    required this.departureCity,
    required this.date,
    required this.arrivalCity,
    required this.departureCode,
    required this.arrivalCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.seatClass,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: onTap,
        child: CustomeShadowCotainner(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/images/citilink.svg', width: 40.w, height: 10.h),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TypographyStyles.small(
                    departureCity,
                    color: GrayColors.gray600,
                    fontWeight: FontWeight.w400,
                    maxlines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TypographyStyles.small(date, color: GrayColors.gray600, fontWeight: FontWeight.w500),
                  TypographyStyles.small(arrivalCity, color: GrayColors.gray600, fontWeight: FontWeight.w400),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TypographyStyles.body(departureCode, color: GrayColors.gray800),
                  SvgPicture.asset('assets/images/ilustrasi_flight.svg'),
                  TypographyStyles.body(arrivalCode, color: GrayColors.gray800),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TypographyStyles.small(departureTime, color: GrayColors.gray600, fontWeight: FontWeight.w400),
                  TypographyStyles.small(duration, color: GrayColors.gray600, fontWeight: FontWeight.w500),
                  TypographyStyles.small(arrivalTime, color: GrayColors.gray600, fontWeight: FontWeight.w400),
                ],
              ),
              SizedBox(height: 16.h),
              SvgPicture.asset('assets/images/divider_custome.svg', width: 348.w),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        CustomeIcons.FlightSeatFilled(),
                        SizedBox(width: 6.w),
                        TypographyStyles.caption(seatClass, color: GrayColors.gray800)
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        TypographyStyles.body(price, color: PrimaryColors.primary800),
                        SizedBox(width: 2.w),
                        TypographyStyles.small('/orang', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
