import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/text/custom_text.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/validators/validators.dart';
import 'package:e_porter/presentation/screens/auth/component/Input_form.dart';
import 'package:e_porter/presentation/screens/auth/component/Input_password.dart';
import 'package:e_porter/presentation/screens/profile/component/header_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  // final _authController = Get.find<ProfilController>();
  final _formKey = GlobalKey<FormState>();
  final _oldPassword = TextEditingController();
  final _newEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Ganti Email',
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
                        'Apakah anda yakin ingin mengganti email akun?. Silahkan masukkan password lama anda sebagai konfirmasi dan masukkan email baru anda',
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
                  CustomText.textPadding8('Email Baru'),
                  SizedBox(height: 16.h),
                  InputForm(
                    controller: _newEmail,
                    hintText: 'example@gmail.com',
                    svgIconPath: 'assets/icons/ic_email.svg',
                    validator: Validators.validatorEmail,
                    textInputType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Obx(() {
      //   return CustomeShadowCotainner(
      //       child: _authController.isChangingEmail.value
      //           ? Center(
      //               child: CircularProgressIndicator(color: PrimaryColors.primary800),
      //             )
      //           : ButtonFill(
      //               text: 'Simpan',
      //               textColor: Colors.white,
      //               onTap: () async {
      //                 if (!_formKey.currentState!.validate()) return;
      //                 await _authController.changeEmailFlow(
      //                   oldPassword: _oldPassword.text,
      //                   newEmail: _newEmail.text.trim(),
      //                 );
      //                 // if (success) {
      //                 //   _oldPassword.clear();
      //                 //   _newEmail.clear();
      //                 //   FocusScope.of(context).unfocus();
      //                 // }
      //               },
      //             ));
      // }),
    );
  }
}
