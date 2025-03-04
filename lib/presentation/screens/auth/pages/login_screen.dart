import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/controllers/auth_controller.dart';
import 'package:e_porter/presentation/screens/auth/component/Input_form.dart';
import 'package:e_porter/presentation/screens/auth/component/Input_password.dart';
import 'package:e_porter/presentation/screens/auth/component/footer_text.dart';
import 'package:e_porter/presentation/screens/auth/component/forget_password.dart';
import 'package:e_porter/presentation/screens/auth/component/header_text.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String? role = Get.arguments as String;
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                      firstText: 'Masuk',
                      secondText: 'Selamat datang kembali! Masuk untuk mengakses pengalaman personal Anda'),
                  SizedBox(height: 50.h),
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
                    controller: authController.emailController,
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
                    controller: authController.passwordController,
                    hintText: '••••••••••',
                    svgIconPath: 'assets/icons/ic_padlock.svg',
                  ),
                  SizedBox(height: 32.h),
                  ForgetPasswordText(
                    onTab: () {
                      Get.toNamed(Routes.FORGETPASSWORD);
                    },
                  ),
                  SizedBox(height: 40.h),
                  Obx(() {
                    if (authController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ZoomTapAnimation(
                        child: ButtonFill(
                          text: 'Masuk',
                          textColor: Colors.white,
                          onTap: () {
                            authController.login(roleFromOnboarding: role);
                          },
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: FooterText(
          firstText: 'Belum punya akun?',
          secondText: 'Daftar',
          onTab: () {
            Get.toNamed(Routes.REGISTER);
          },
        ),
      ),
    );
  }
}
