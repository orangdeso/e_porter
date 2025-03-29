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
  final String? transiAirplane;
  final String? stop;
  final String? departurePorter;
  final String? arrivalPorter;
  final String? transitPorter;
  final String? airlineLogo;

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
    this.transiAirplane,
    this.stop,
    this.departurePorter,
    this.arrivalPorter,
    this.transitPorter,
    this.airlineLogo,
  });

  @override
  Widget build(BuildContext context) {
    return CustomeShadowCotainner(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          airlineLogo != null && airlineLogo!.isNotEmpty
              ? Image.network(
                  airlineLogo!,
                  width: 40.w,
                  height: 26.h,
                  errorBuilder: (context, error, stackTrace) {
                    print("Error loading image: $error");
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
              : SvgPicture.asset('assets/images/citilink.svg', width: 40.w, height: 10.h),
          SizedBox(height: 10.h),
          Row(
            children: [
              if (stop != null && stop!.isNotEmpty) ...[
                TypographyStyles.small('${stop}', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                SizedBox(width: 10.w),
                CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
                SizedBox(width: 10.w),
              ],
              TypographyStyles.small(date, color: GrayColors.gray600, fontWeight: FontWeight.w400),
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
              if (transiAirplane != null && transiAirplane!.isNotEmpty) ...[
                TypographyStyles.body('${transiAirplane}', color: GrayColors.gray800),
                SizedBox(width: 10.w),
                CustomeIcons.PlaneRightFilled(color: PrimaryColors.primary800),
                SizedBox(width: 10.w),
              ],
              TypographyStyles.body(arrivalCity, color: GrayColors.gray800),
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
          if (departurePorter != null && departurePorter!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            TypographyStyles.small(departurePorter!, color: GrayColors.gray600, fontWeight: FontWeight.w400),
          ],
          if (arrivalPorter != null && arrivalPorter!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            TypographyStyles.small(arrivalPorter!, color: GrayColors.gray600, fontWeight: FontWeight.w400),
          ],
          if (transitPorter != null && transitPorter!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            TypographyStyles.small(transitPorter!, color: GrayColors.gray600, fontWeight: FontWeight.w400),
          ],
          SizedBox(height: 4.h),
          TypographyStyles.small(
            '$passenger Dewasa',
            color: GrayColors.gray600,
            fontWeight: FontWeight.w400,
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
