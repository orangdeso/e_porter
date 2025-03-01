import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
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
                TypographyStyles.h6('Pilih Kursi', color: GrayColors.gray800),
                SizedBox(height: 20.h),
                _buildCardSeatPessenger(
                  context,
                  label: '1',
                  namePassenger: 'AHMAD CHOIRUL UMAM ALI R',
                  seatClass: 'Economy',
                  numberSeat: '10F',
                  onTap: () {
                    Get.toNamed(Routes.CHOOSECHAIR);
                  },
                ),
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
              Get.toNamed(Routes.TICKETBOOKINGSTEP3);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardSeatPessenger(BuildContext context,
      {required String label,
      required String namePassenger,
      required String seatClass,
      required String numberSeat,
      required VoidCallback onTap}) {
    return CustomeShadowCotainner(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypographyStyles.caption(
                'Penumpang ${label} (Dewasa)',
                color: GrayColors.gray600,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
              SizedBox(height: 2.h),
              TypographyStyles.body(
                namePassenger,
                color: GrayColors.gray800,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
                maxlines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              TypographyStyles.caption(
                '${seatClass} / ${numberSeat}',
                color: GrayColors.gray600,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              )
            ],
          ),
          ZoomTapAnimation(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5.w, color: PrimaryColors.primary800),
                  borderRadius: BorderRadius.circular(35.r),
                ),
                child: TypographyStyles.caption(
                  'Pilih Kursi',
                  color: PrimaryColors.primary800,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
