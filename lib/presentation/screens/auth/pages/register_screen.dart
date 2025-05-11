import 'dart:developer';

import 'package:e_porter/_core/utils/formatter/uppercase_helper.dart';
import 'package:e_porter/_core/validators/validators.dart';
import 'package:e_porter/presentation/controllers/auth_controller.dart';
import 'package:e_porter/presentation/screens/auth/component/header_text.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
  final String? role = Get.arguments as String;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _verifPassword = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      if (_password.text != _verifPassword.text) {
        Get.snackbar(
          'Error',
          'Password tidak cocok',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      _authController.register(
        name: _name.text,
        email: _email.text,
        password: _password.text,
        role: role.toString(),
      );
      log('Role Registrasi: $role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(
                      firstText: 'Daftar',
                      secondText: 'Segera daftarkan diri anda ke aplikasi ini untuk akses penuh ke fitur kami!',
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
                      controller: _name,
                      hintText: 'SUPARJO',
                      svgIconPath: 'assets/icons/ic_account.svg',
                      validator: Validators.validatorName,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                        UpperCaseTextFormatter(),
                      ],
                      textInputType: TextInputType.text,
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
                      controller: _email,
                      hintText: 'example@gmail.com',
                      svgIconPath: 'assets/icons/ic_email.svg',
                      validator: Validators.validatorEmail,
                      textInputType: TextInputType.emailAddress,
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
                      controller: _password,
                      hintText: '••••••••••',
                      svgIconPath: 'assets/icons/ic_padlock.svg',
                      validator: Validators.validatorPassword,
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
                      controller: _verifPassword,
                      hintText: '••••••••••',
                      svgIconPath: 'assets/icons/ic_padlock.svg',
                      validator: Validators.validatorConfirmPassword(_password),
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
            Obx(
              () => ZoomTapAnimation(
                child: ButtonFill(
                  text: _authController.isLoading.value ? 'Loading...' : 'Daftar',
                  textColor: Colors.white,
                  onTap: _authController.isLoading.value ? null : _handleRegister,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            FooterText(
              firstText: 'Sudah punya akun?',
              secondText: 'Masuk',
              onTab: () {
                Get.toNamed(Routes.LOGIN, arguments: role);
              },
            ),
          ],
        ),
      ),
    );
  }
}
