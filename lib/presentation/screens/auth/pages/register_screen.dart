import 'package:e_porter/presentation/screens/auth/component/header_text.dart';
import 'package:e_porter/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/button/button_fill.dart';
import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';
import '../component/Input_form.dart';
import '../component/Input_password.dart';
import '../component/footer_text.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                  firstText: 'Daftar',
                  secondText:
                      'Segera daftarkan diri anda ke aplikasi ini untuk akses penuh ke fitur kami!',
                ),
                SizedBox(height: 50.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: TypographyStyles.body(
                    'Nama',
                    color: GrayColors.gray800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                InputForm(
                  hintText: 'Suparjo',
                  svgIconPath: 'assets/icons/ic_account.svg',
                ),
                SizedBox(height: 20.h),
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
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: TypographyStyles.body(
                    'Password',
                    color: GrayColors.gray800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                InputPassword(
                  hintText: '••••••••••',
                  svgIconPath: 'assets/icons/ic_padlock.svg',
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: TypographyStyles.body(
                    'Konfirmasi Password',
                    color: GrayColors.gray800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                InputPassword(
                  hintText: '••••••••••',
                  svgIconPath: 'assets/icons/ic_padlock.svg',
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
                text: 'Daftar',
                textColor: Colors.white,
                onTap: () {
                  Get.toNamed(Routes.STATESUCCES);
                },
              ),
            ),
            SizedBox(height: 20.h),
            FooterText(
              firstText: 'Sudah punya akun?',
              secondText: 'Masuk',
              onTab: () {
                Get.toNamed(Routes.LOGIN);
              },
            ),
          ],
        ),
      ),
    );
  }
}
