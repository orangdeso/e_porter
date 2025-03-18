import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/home/component/card_tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../_core/component/appbar/appbar_component.dart';

class PrintBoardingPassScreen extends StatelessWidget {
  const PrintBoardingPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Detail Tiket',
        textColor: Colors.white,
        backgroundColors: PrimaryColors.primary800,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomeShadowCotainner(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TypographyStyles.caption(
                            'Kode Booking Maskapai',
                            color: GrayColors.gray500,
                            fontWeight: FontWeight.w400,
                          ),
                          TypographyStyles.h6('text', color: GrayColors.gray800),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(thickness: 1, color: GrayColors.gray200),
                      ),
                      CardTickets(
                        withContainer: false,
                        departureCity: 'departureCity',
                        date: 'date',
                        arrivalCity: 'arrivalCity',
                        departureCode: 'YIA',
                        arrivalCode: 'LOP',
                        departureTime: 'departureTime',
                        arrivalTime: 'arrivalTime',
                        duration: 'duration',
                        seatClass: 'seatClass',
                        price: 'price',
                        onTap: () {},
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
