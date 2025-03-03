import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/button/button_fill.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Kode QRIS',
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
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TypographyStyles.h5("E-Porter", color: GrayColors.gray800),
                  SizedBox(height: 10.h),
                  TypographyStyles.body("Citilink (103)", color: GrayColors.gray800, fontWeight: FontWeight.w400),
                  SizedBox(height: 16.h),
                  TypographyStyles.h5("Rp 2.460.000", color: GrayColors.gray800),
                  SizedBox(height: 32.h),
                  SvgPicture.asset('assets/images/qris.svg'),
                  SizedBox(height: 20.h),
                  TypographyStyles.small(
                    "Berlaku hingga : 28 Januari 2025, 16:40",
                    color: GrayColors.gray600,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        child: ZoomTapAnimation(
          child: ButtonFill(
            text: 'Lanjutkan',
            textColor: Colors.white,
            onTap: () {
              // Get.toNamed(Routes.TICKETBOOKINGSTEP2);
            },
          ),
        ),
      ),
    );
  }
}
