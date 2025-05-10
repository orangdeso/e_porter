import 'dart:async';

import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/controllers/auth_controller.dart';
import 'package:e_porter/presentation/screens/auth/component/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class VerifikasiScreen extends StatefulWidget {
  VerifikasiScreen({super.key});

  @override
  State<VerifikasiScreen> createState() => _VerifikasiScreenState();
}

class _VerifikasiScreenState extends State<VerifikasiScreen> {
  final AuthController _authController = Get.find();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await _authController.completeEmailVerification();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeaderText(
                  firstText: 'Verifikasi Email',
                  secondText: 'Kami telah mengirimkan link verifikasi melalui email anda. Silahkan cek email anda',
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: SvgPicture.asset('assets/images/il_email.svg'),
                ),
                SizedBox(height: 32.h),
                _buildSendVerification(
                  onTap: _authController.resendEmailVerification,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSendVerification({required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TypographyStyles.body(
          'Kirim ulang verifikasi?',
          color: GrayColors.gray600,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(width: 8.w),
        ZoomTapAnimation(
          child: GestureDetector(
            onTap: onTap,
            child: TypographyStyles.body('Kirim Ulang', color: Colors.blue.shade600),
          ),
        )
      ],
    );
  }
}
