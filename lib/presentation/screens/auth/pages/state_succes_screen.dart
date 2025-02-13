import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class StateSuccesScreen extends StatelessWidget {
  const StateSuccesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/taxi_female.svg'),
                    SizedBox(height: 44.h),
                    TypographyStyles.h3(
                      'Verifikasi Berhasil',
                      color: GrayColors.gray800,
                      maxlines: 2,
                    ),
                    SizedBox(height: 20.h),
                    TypographyStyles.h6(
                      'Selamat! Akun anda telah berhasil diverifikasi. Sekarang kamu dapat mencoba berbagai fitur di aplikasi ini',
                      color: GrayColors.gray600,
                      fontWeight: FontWeight.w500,
                      maxlines: 4,
                      textAlign: TextAlign.center,
                    )
                  ],
                ))),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: ZoomTapAnimation(
              child: ButtonFill(
                text: 'Lanjutkan',
                textColor: Colors.white,
                onTap: () {},
              ),
            )));
  }
}
