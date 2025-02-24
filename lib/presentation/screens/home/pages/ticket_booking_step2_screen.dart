import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_outline.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/button/button_fill.dart';
import '../../../../_core/constants/typography.dart';
import '../component/card_flight_information.dart';

class TicketBookingStep2Screen extends StatefulWidget {
  const TicketBookingStep2Screen({super.key});

  @override
  State<TicketBookingStep2Screen> createState() => _TicketBookingStep2ScreenState();
}

class _TicketBookingStep2ScreenState extends State<TicketBookingStep2Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: ProgressAppbarComponent(
        title: 'Pesan Tiket',
        subTitle: 'Langkah 2 dari 4',
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardFlightInformation(
                  date: 'Sen, 27 Jan 2025',
                  time: '12.20 - 06.00 AM',
                  departureCity: 'Yogyakarta',
                  arrivalCity: 'Lombok',
                  plane: 'Citilink (103)',
                  seatClass: 'Economy',
                  passenger: '2',
                ),
                SizedBox(height: 32.h),
                TypographyStyles.h6('Pilih Kursi', color: GrayColors.gray800, letterSpacing: 0.2),
                SizedBox(height: 20.h),
                _buildCardSeatPessenger(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: ZoomTapAnimation(
          child: ButtonFill(
            text: 'Lanjutkan',
            textColor: Colors.white,
            onTap: () {
              Get.toNamed(Routes.CHOOSECHAIR);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardSeatPessenger() {
    return CustomeShadowCotainner(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypographyStyles.caption(
                'Penumpang 1 (Dewasa)',
                color: GrayColors.gray600,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
              SizedBox(height: 2.h),
              TypographyStyles.body(
                'AHMAD CHOIRUL UMAM ALI',
                color: GrayColors.gray800,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
                maxlines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              TypographyStyles.caption(
                'Economy / 10F',
                color: GrayColors.gray600,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: ZoomTapAnimation(
                child: ButtonOutline(
                  text: 'Pilih Kursi',
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  textColor: PrimaryColors.primary800,
                  customTextStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: PrimaryColors.primary800,
                    letterSpacing: 0.1,
                  ),
                  onTap: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
