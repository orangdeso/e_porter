import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/card/custome_shadow_cotainner.dart';
import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';

class CardBoardingPass extends StatelessWidget {
  final bool isActive;
  final VoidCallback? onTap;

  const CardBoardingPass({Key? key, required this.isActive, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            _buildHeaderStatus(),
            CustomeShadowCotainner(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.r),
                bottomRight: Radius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isActive)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            TypographyStyles.body('Kode Booking',
                                color: GrayColors.gray600, fontWeight: FontWeight.w400),
                            SizedBox(width: 20.w),
                            TypographyStyles.body('I2L8JRL', color: GrayColors.gray800),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: GrayColors.gray100,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(width: 1.w, color: GrayColors.gray200),
                          ),
                          child: TypographyStyles.caption('Keberangkatan', color: GrayColors.gray800),
                        ),
                      ],
                    ),
                  if (!isActive)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: RedColors.red200,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TypographyStyles.caption("Batas Pembayaran",
                              color: RedColors.red600, fontWeight: FontWeight.w400),
                          TypographyStyles.caption("01:07:12", color: RedColors.red600)
                        ],
                      ),
                    ),
                  SizedBox(height: 22.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TypographyStyles.caption("Citilink (103)", color: GrayColors.gray800),
                      SizedBox(width: 10.w),
                      SvgPicture.asset('assets/images/citilink.svg', width: 40.w, height: 10.h),
                    ],
                  ),
                  SizedBox(height: 4.w),
                  Row(
                    children: [
                      TypographyStyles.small(
                        'Fast Track (FT)',
                        color: GrayColors.gray600,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.w400,
                      ),
                      _buildText(context, text: 'Economy'),
                      _buildText(context, text: '2 Dewasa'),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  SvgPicture.asset('assets/images/divider_custome.svg', width: 348.w),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TypographyStyles.caption("12:20", color: GrayColors.gray800),
                          TypographyStyles.small("Sen, 27 Jan", color: GrayColors.gray600, fontWeight: FontWeight.w400),
                          SizedBox(height: 20.h),
                          TypographyStyles.small("5j 40m", color: GrayColors.gray600, fontWeight: FontWeight.w400),
                          SizedBox(height: 20.h),
                          TypographyStyles.caption("12:20", color: GrayColors.gray800),
                          TypographyStyles.small("Sen, 27 Jan", color: GrayColors.gray600, fontWeight: FontWeight.w400),
                        ],
                      ),
                      SizedBox(width: 20.w),
                      SvgPicture.asset('assets/images/garis.svg', height: 100.h),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TypographyStyles.caption("Yogyakarta (YIA)", color: GrayColors.gray800),
                            TypographyStyles.caption(
                              "Bandar YIA, Terminal Domestic",
                              color: GrayColors.gray600,
                              fontWeight: FontWeight.w400,
                              maxlines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 58.h),
                            TypographyStyles.caption("Yogyakarta (YIA)", color: GrayColors.gray800),
                            TypographyStyles.caption(
                              "Bandar Zainuddin Abdul Madjid, Terminal Domestic",
                              color: GrayColors.gray600,
                              fontWeight: FontWeight.w400,
                              maxlines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStatus() {
    final Color headerColor = isActive ? GreenColors.green100 : GrayColors.gray500;
    if (isActive) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: headerColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
        ),
        child: Center(
          child: TypographyStyles.body("Aktif", color: GreenColors.green500),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: headerColor,
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
