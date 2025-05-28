import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/button/button_outline.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  late final passenger = '1';
  late final porter = '2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/images/ilustrasi_onboarding.svg',
              ),
              SizedBox(height: 16.h),
              TypographyStyles.h6(
                'Hemat waktu Anda di bandara dengan layanan E-Porter. Kami siap membantu setiap kebutuhan perjalanan prioritas Anda dengan mudah dan cepat',
                fontWeight: FontWeight.w600,
                color: GrayColors.gray600,
                textAlign: TextAlign.center,
                maxlines: 5,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ZoomTapAnimation(
              child: ButtonFill(
                text: 'Masuk sebagai Penumpang',
                textColor: Colors.white,
                onTap: () {
                  Get.toNamed(Routes.LOGIN, arguments: 'penumpang');
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            ZoomTapAnimation(
              child: ButtonOutline(
                text: 'Masuk sebagai Porter',
                textColor: PrimaryColors.primary800,
                onTap: () {
                  Get.toNamed(Routes.LOGIN, arguments: 'porter');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
