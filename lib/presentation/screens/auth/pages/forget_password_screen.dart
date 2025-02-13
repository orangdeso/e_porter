import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/button/button_no_fill.dart';
import 'package:e_porter/presentation/screens/auth/component/header_text.dart';
import 'package:e_porter/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';
import '../component/Input_form.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(
                  firstText: 'Atur\nUlang Password',
                  secondText:
                      'Jangan khawatir, kami akan mengirimkan petunjuk atur ulang password Anda',
                ),
                SizedBox(height: 10.h),
                Center(
                    child: SvgPicture.asset('assets/images/taxi_homework.svg')),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: TypographyStyles.body(
                    'Email',
                    color: GrayColors.gray800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                InputForm(
                  hintText: 'example@gmail.com',
                  svgIconPath: 'assets/icons/ic_email.svg',
                ),
              ],
            )),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ZoomTapAnimation(
              child: ButtonFill(
                text: 'Atur Ulang Password',
                textColor: Colors.white,
                onTap: () {},
              ),
            ),
            SizedBox(height: 10.h),
            ZoomTapAnimation(
              child: ButtonNoFill(
                text: 'Kembali untuk Masuk',
                textColor: GrayColors.gray500,
                onTap: () {
                  Get.toNamed(Routes.LOGIN);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
