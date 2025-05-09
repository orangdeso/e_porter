import 'dart:developer';
import 'package:e_porter/presentation/screens/boarding_pass/component/payment_count_down_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/card/custome_shadow_cotainner.dart';
import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';

class CardBoardingPass extends StatelessWidget {
  final bool isActive;
  final String idBooking;
  final String? opsiFlight;
  final DateTime? expiryTime;
  final String? airlines;
  final String? codeAirlines;
  final String? logo;
  final List<String>? servicePorter;
  final String? flightClass;
  final int? passenger;
  final String? departureCity;
  final String? arrivalCity;
  final String? departureCode;
  final String? arrivalCode;
  final String? departurePlane;
  final String? arrivalPlane;
  final String? transitCity;
  final String? transitPlane;
  final String? transitCode;
  final String? transitStartDate;
  final String? transitEndDate;
  final String? departureTime;
  final String? arrivalTime;
  final String? departureDate;
  final String? arrivalDate;
  final String? duration;
  final String? stop;
  final VoidCallback? onTap;

  const CardBoardingPass({
    Key? key,
    required this.isActive,
    required this.idBooking,
    this.opsiFlight,
    this.expiryTime,
    this.airlines,
    this.codeAirlines,
    this.logo,
    this.servicePorter,
    this.flightClass,
    this.passenger,
    this.departureCity,
    this.arrivalCity,
    this.departureCode,
    this.arrivalCode,
    this.departurePlane,
    this.arrivalPlane,
    this.transitCity,
    this.transitPlane,
    this.transitCode,
    this.transitStartDate,
    this.transitEndDate,
    this.departureTime,
    this.arrivalTime,
    this.departureDate,
    this.arrivalDate,
    this.duration,
    this.stop,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            _buildHeaderStatus(idBooking: idBooking, opsiFlight: opsiFlight),
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
                            TypographyStyles.body(idBooking, color: GrayColors.gray800),
                          ],
                        ),
                        if (opsiFlight != null && opsiFlight!.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: GrayColors.gray100,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(width: 1.w, color: GrayColors.gray200),
                            ),
                            child: TypographyStyles.caption(opsiFlight!, color: GrayColors.gray800),
                          )
                        else
                          SizedBox.shrink(),
                      ],
                    ),
                  if (!isActive) PaymentCountdownTimer(expiryTime: expiryTime!),
                  SizedBox(height: 22.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TypographyStyles.caption("${airlines} (${codeAirlines})", color: GrayColors.gray800),
                      SizedBox(width: 10.w),
                      logo != null && logo!.isNotEmpty
                          ? Image.network(
                              logo!,
                              width: 40.w,
                              height: 26.h,
                              errorBuilder: (context, error, stackTrace) {
                                log("Error loading image: $error");
                                return Container(
                                  width: 40.w,
                                  height: 10.h,
                                  child: Center(child: Icon(Icons.error)),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 40.w,
                                  height: 10.h,
                                  child: Center(child: CircularProgressIndicator(strokeWidth: 1.0)),
                                );
                              },
                            )
                          : SvgPicture.asset('assets/images/citilink.svg', width: 10.w, height: 10.h),
                    ],
                  ),
                  SizedBox(height: 4.w),
                  Wrap(
                    spacing: 4.w,
                    runSpacing: 4.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: _buildInfoItems(),
                  ),
                  SizedBox(height: 20.h),
                  SvgPicture.asset('assets/images/divider_custome.svg', width: 348.w),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TypographyStyles.caption("$departureTime", color: GrayColors.gray800),
                          TypographyStyles.small("$departureDate",
                              color: GrayColors.gray600, fontWeight: FontWeight.w400),
                          SizedBox(height: 20.h),
                          TypographyStyles.small("$duration", color: GrayColors.gray600, fontWeight: FontWeight.w400),
                          SizedBox(height: 20.h),
                          TypographyStyles.caption("$arrivalTime", color: GrayColors.gray800),
                          TypographyStyles.small("$arrivalDate",
                              color: GrayColors.gray600, fontWeight: FontWeight.w400),
                        ],
                      ),
                      SizedBox(width: 20.w),
                      SvgPicture.asset('assets/images/garis.svg', height: 100.h),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TypographyStyles.caption("$departureCity ($departureCode)", color: GrayColors.gray800),
                            TypographyStyles.caption(
                              "$departurePlane",
                              color: GrayColors.gray600,
                              fontWeight: FontWeight.w400,
                              maxlines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 20.h),
                            if (transitCity != null &&
                                transitCity!.isNotEmpty &&
                                transitCode != null &&
                                transitCode!.isNotEmpty &&
                                transitPlane != null &&
                                transitPlane!.isNotEmpty) ...[
                              TypographyStyles.caption("$transitCity ($transitCode)", color: GrayColors.gray800),
                              TypographyStyles.caption(
                                "$transitPlane",
                                color: GrayColors.gray600,
                                fontWeight: FontWeight.w400,
                                maxlines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 20.h),
                            ],
                            TypographyStyles.caption("$arrivalCity ($arrivalCode)", color: GrayColors.gray800),
                            TypographyStyles.caption(
                              "$arrivalPlane",
                              color: GrayColors.gray600,
                              fontWeight: FontWeight.w400,
                              maxlines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
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

  Widget _buildHeaderStatus({required String idBooking, required String? opsiFlight}) {
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
              TypographyStyles.body(idBooking, color: Colors.white),
            ],
          ),
          if (opsiFlight != null && opsiFlight.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
              child: TypographyStyles.caption(opsiFlight, color: GrayColors.gray800),
            )
          else
            SizedBox.shrink()
        ],
      ),
    );
  }

  List<Widget> _buildInfoItems() {
    List<Widget> items = [];

    if (servicePorter != null && servicePorter!.isNotEmpty) {
      for (int i = 0; i < servicePorter!.length; i++) {
        items.add(TypographyStyles.small(
          servicePorter![i],
          color: GrayColors.gray600,
          letterSpacing: 0.2,
          fontWeight: FontWeight.w400,
        ));

        if (i < servicePorter!.length - 1 || flightClass != null) {
          items.add(SizedBox(width: 5.w));
          items.add(CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)));
          items.add(SizedBox(width: 5.w));
        }
      }
    }

    if (flightClass != null && flightClass!.isNotEmpty) {
      items.add(TypographyStyles.small(
        flightClass!,
        color: GrayColors.gray600,
        letterSpacing: 0.2,
        fontWeight: FontWeight.w400,
      ));

      items.add(SizedBox(width: 5.w));
      items.add(CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)));
      items.add(SizedBox(width: 5.w));
    }

    items.add(TypographyStyles.small(
      "${passenger ?? 1} Dewasa",
      color: GrayColors.gray600,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w400,
    ));

    return items;
  }
}
