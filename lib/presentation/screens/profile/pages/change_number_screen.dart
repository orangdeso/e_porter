import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/text/custom_text.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/validators/validators.dart';
import 'package:e_porter/presentation/controllers/profil_controller.dart';
import 'package:e_porter/presentation/screens/auth/component/Input_form.dart';
import 'package:e_porter/presentation/screens/auth/component/Input_password.dart';
import 'package:e_porter/presentation/screens/profile/component/header_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangeNumberScreen extends StatefulWidget {
  const ChangeNumberScreen({super.key});

  @override
  State<ChangeNumberScreen> createState() => _ChangeNumberScreenState();
}

class _ChangeNumberScreenState extends State<ChangeNumberScreen> {
  final _profilController = Get.find<ProfilController>();
  final _formKey = GlobalKey<FormState>();
  final _oldPassword = TextEditingController();
  final _phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Ganti Nomor Telepon',
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
                        'Apakah anda yakin ingin mengganti nomor telepon akun?. Silahkan masukkan password lama anda sebagai verifikasi dan nomor telepon baru anda',
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
                  CustomText.textPadding8('Nomor Telepon'),
                  SizedBox(height: 16.h),
                  InputForm(
                    controller: _phoneNumber,
                    hintText: '0821xx',
                    svgIconPath: 'assets/icons/ic_phone.svg',
                    validator: Validators.validatorPhone,
                    textInputType: TextInputType.number,
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
            child: _profilController.isChangingPhone.value
                ? Center(
                    child: CircularProgressIndicator(color: PrimaryColors.primary800),
                  )
                : ButtonFill(
                    text: 'Simpan',
                    textColor: Colors.white,
                    onTap: () async {
                      if (!_formKey.currentState!.validate()) return;
                      final result = await _profilController.changePhone(
                        oldPassword: _oldPassword.text.trim(),
                        newPhone: _phoneNumber.text.trim(),
                      );
                      if (result) {
                        _oldPassword.clear();
                        _phoneNumber.clear();
                      }
                    },
                  ),
          );
        },
      ),
    );
  }
}
