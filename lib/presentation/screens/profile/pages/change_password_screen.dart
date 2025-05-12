import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/_core/validators/validators.dart';
import 'package:e_porter/presentation/screens/auth/component/Input_password.dart';
import 'package:e_porter/presentation/screens/profile/component/header_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Ganti Kata Sandi',
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderInformation(
                    title:
                        'Apakah anda yakin ingin mengganti kata sandi? Silahkan masukkan kata sandi lama anda dan kata sandi baru anda',
                  ),
                  SizedBox(height: 32.h),
                  textTitle(title: 'Password Lama'),
                  SizedBox(height: 16.h),
                  InputPassword(
                    controller: _oldPassword,
                    hintText: '••••••••••',
                    svgIconPath: 'assets/icons/ic_padlock.svg',
                    validator: Validators.validatorPassword,
                  ),
                  SizedBox(height: 20.h),
                  textTitle(title: 'Password Baru'),
                  SizedBox(height: 16.h),
                  InputPassword(
                    controller: _newPassword,
                    hintText: '••••••••••',
                    svgIconPath: 'assets/icons/ic_padlock.svg',
                    validator: Validators.validatorPassword,
                  ),
                  SizedBox(height: 20.h),
                  textTitle(title: 'Konfirmasi Password'),
                  SizedBox(height: 16.h),
                  InputPassword(
                    controller: _confirmPassword,
                    hintText: '••••••••••',
                    svgIconPath: 'assets/icons/ic_padlock.svg',
                    validator: Validators.validatorPassword,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        child: ButtonFill(
          text: 'Simpan',
          textColor: Colors.white,
          onTap: () {
            if (_formKey.currentState!.validate()) {}
          },
        ),
      ),
    );
  }

  Widget textTitle({required String title}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: TypographyStyles.body(
        title,
        color: GrayColors.gray800,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
