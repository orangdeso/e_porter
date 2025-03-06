// ignore_for_file: deprecated_member_use

import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardTransaction extends StatelessWidget {
  const CardTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: GrayColors.gray300,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypographyStyles.small("Kode Booking", color: Colors.white, fontWeight: FontWeight.w400),
                  TypographyStyles.body("I2L8JRL", color: Colors.white)
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4),
                decoration: BoxDecoration(
                  color: GreenColors.green100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TypographyStyles.small("Sudah Digunakan", color: GreenColors.green500),
              )
            ],
          ),
        ),
        CustomeShadowCotainner(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.r),
            bottomRight: Radius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset('assets/images/citilink.svg', width: 40.w, height: 10.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TypographyStyles.small(
                        'Sen, 27 Jan 2025 ',
                        color: GrayColors.gray600,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(width: 10.w),
                      CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
                      SizedBox(width: 10.w),
                      TypographyStyles.small('5j 40m', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      TypographyStyles.body('YIA', color: GrayColors.gray800),
                      SizedBox(width: 10.w),
                      SvgPicture.asset(
                        'assets/icons/ic_right.svg',
                        color: GrayColors.gray800,
                        width: 14.w,
                        height: 14.h,
                      ),
                      SizedBox(width: 10.w),
                      TypographyStyles.body('LOP', color: GrayColors.gray800),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      TypographyStyles.small(
                        'Economy',
                        color: GrayColors.gray600,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(width: 10.w),
                      CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
                      SizedBox(width: 10.w),
                      TypographyStyles.small('Fast Track (FT)', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TypographyStyles.small('Total Harga', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                  TypographyStyles.caption("Rp 1.410.000", color: PrimaryColors.primary800)
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
