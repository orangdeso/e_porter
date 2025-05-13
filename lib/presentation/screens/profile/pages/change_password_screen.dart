import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/text/custom_text.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/utils/snackbar/snackbar_helper.dart';
import 'package:e_porter/_core/validators/validators.dart';
import 'package:e_porter/presentation/controllers/profil_controller.dart';
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
  final _authController = Get.find<ProfilController>();
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
                    CustomText.textPadding8('Password Lama'),
                    SizedBox(height: 16.h),
                    InputPassword(
                      controller: _oldPassword,
                      hintText: '••••••••••',
                      svgIconPath: 'assets/icons/ic_padlock.svg',
                      validator: Validators.validatorPassword,
                    ),
                    SizedBox(height: 20.h),
                    CustomText.textPadding8('Password Baru'),
                    SizedBox(height: 16.h),
                    InputPassword(
                      controller: _newPassword,
                      hintText: '••••••••••',
                      svgIconPath: 'assets/icons/ic_padlock.svg',
                      validator: Validators.validatorPassword,
                    ),
                    SizedBox(height: 20.h),
                    CustomText.textPadding8('Konfirmasi Password'),
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
        bottomNavigationBar: Obx(
          () {
            return CustomeShadowCotainner(
              child: _authController.isChangingPassword.value
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : ButtonFill(
                      text: 'Simpan',
                      textColor: Colors.white,
                      onTap: () async {
                        if (!_formKey.currentState!.validate()) return;
                        if (_newPassword.text != _confirmPassword.text) {
                          SnackbarHelper.showError("Error", "Password baru dan konfirmasi tidak sama.");
                          return;
                        }

                        final success = await _authController.changePassword(
                          oldPassword: _oldPassword.text,
                          newPassword: _newPassword.text,
                        );

                        if (success) {
                          _oldPassword.clear();
                          _newPassword.clear();
                          _confirmPassword.clear();
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
            );
          },
        ));
  }
}
