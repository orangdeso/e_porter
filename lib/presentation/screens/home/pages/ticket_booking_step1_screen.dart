import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/button/switch_button.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/home/component/card_flight_information.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class TicketBookingStep1Screen extends StatefulWidget {
  const TicketBookingStep1Screen({super.key});

  @override
  State<TicketBookingStep1Screen> createState() => _TicketBookingStep1ScreenState();
}

class _TicketBookingStep1ScreenState extends State<TicketBookingStep1Screen> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: ProgressAppbarComponent(
        title: 'Pesan Tiket',
        subTitle: 'Langkah 1 dari 4',
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
                TypographyStyles.h6('Detail Pemesanan', color: GrayColors.gray800, letterSpacing: 0.2),
                SizedBox(height: 20.h),
                _buildCardUsers('AHMAD CHOIRUL UMAM ALI R', 'ahmadzaqi98mmm@gmail.com', '082142568403'),
                SizedBox(height: 32.h),
                TypographyStyles.h6('Detail Penumpang', color: GrayColors.gray800, letterSpacing: 0.2),
                SizedBox(height: 20.h),
                _buildCardDetailPessenger()
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
              Get.toNamed(Routes.TICKETBOOKINGSTEP2);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardUsers(final String name, String email, String noTelpon) {
    return CustomeShadowCotainner(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypographyStyles.small('Nama', fontWeight: FontWeight.w400, color: GrayColors.gray600, letterSpacing: 0.2),
          SizedBox(height: 10.h),
          TypographyStyles.body(name, color: GrayColors.gray800, fontWeight: FontWeight.w500, letterSpacing: 0.2),
          SizedBox(height: 16.h),
          TypographyStyles.small('Email', fontWeight: FontWeight.w400, color: GrayColors.gray600, letterSpacing: 0.2),
          SizedBox(height: 10.h),
          TypographyStyles.body(email, color: GrayColors.gray800, fontWeight: FontWeight.w500, letterSpacing: 0.2),
          SizedBox(height: 16.h),
          TypographyStyles.small('No Telepon',
              fontWeight: FontWeight.w400, color: GrayColors.gray600, letterSpacing: 0.2),
          SizedBox(height: 10.h),
          TypographyStyles.body(noTelpon, color: GrayColors.gray800, fontWeight: FontWeight.w500, letterSpacing: 0.2),
          SizedBox(height: 20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TypographyStyles.caption(
                'Tambahkan sebagai penumpang',
                color: GrayColors.gray800,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
              SizedBox(width: 20.w),
              SwitchButton(
                value: isToggled,
                onChanged: (newValue) {
                  setState(
                    () {
                      isToggled = newValue;
                    },
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCardDetailPessenger() {
    return CustomeShadowCotainner(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TypographyStyles.body(
            'Penumpang 1 (Dewasa)',
            color: GrayColors.gray800,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
          ZoomTapAnimation(
            child: GestureDetector(
              onTap: () {},
              child: CustomeIcons.EditOutline(),
            ),
          )
        ],
      ),
    );
  }
}
