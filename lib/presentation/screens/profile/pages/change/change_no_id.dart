import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/text/custom_text.dart';
import 'package:e_porter/_core/component/text_field/dropdown/dropdown_component.dart';
import 'package:e_porter/_core/component/text_field/text_input/text_field_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/_core/validators/validators.dart';
import 'package:e_porter/presentation/screens/auth/component/Input_password.dart';
import 'package:e_porter/presentation/screens/profile/component/header_information.dart';
import 'package:e_porter/presentation/controllers/profil_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangeNoId extends StatefulWidget {
  const ChangeNoId({super.key});

  @override
  State<ChangeNoId> createState() => _ChangeNoIdState();
}

class _ChangeNoIdState extends State<ChangeNoId> {
  final _formKey = GlobalKey<FormState>();
  final _oldPassword = TextEditingController();
  final _noIdController = TextEditingController();
  final ProfilController _profilController = Get.find<ProfilController>();

  String selectedTypeId = 'KTP';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppbarComponent(
        title: 'Ganti Nomor ID',
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
                        'Apakah anda yakin ingin mengganti Nomor ID akun anda?. Silahkan masukkan password lama anda sebagai verifikasi dan Type Nomor ID baru anda',
                  ),
                  SizedBox(height: 32.h),
                  CustomText.textPadding8('Password Lama'),
                  SizedBox(height: 16.h),
                  InputPassword(
                    controller: _oldPassword,
                    hintText: '••••••••••',
                    svgIconPath: 'assets/icons/ic_padlock.svg',
                    backgroundColor: Colors.white,
                    validator: Validators.validatorPassword,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TypographyStyles.body('Tipe ID', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                          SizedBox(height: 16.h),
                          DropdownComponent(
                            hintText: "Pilih jenis dokument",
                            items: ['KTP', 'Pasport'],
                            value: selectedTypeId,
                            onChanged: (value) {
                              setState(() {
                                selectedTypeId = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TypographyStyles.body('No ID', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                            SizedBox(height: 16.h),
                            TextFieldComponent(
                              controller: _noIdController,
                              hintText: 'Masukkan ID',
                              validators: Validators.validatorNoID,
                              textInputType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(16),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return CustomeShadowCotainner(
          child: _profilController.isChangingNoId.value
              ? Center(
                  child: CircularProgressIndicator(color: PrimaryColors.primary800),
                )
              : ButtonFill(
                  text: 'Simpan',
                  textColor: Colors.white,
                  onTap: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final result = await _profilController.changeNoId(
                        oldPassword: _oldPassword.text.trim(),
                        noId: _noIdController.text.trim(),
                        typeId: selectedTypeId);

                    if (result) {
                      _oldPassword.clear();
                      _noIdController.clear();

                      await Future.delayed(Duration(milliseconds: 1500));

                      if (Get.isSnackbarOpen) {
                        Get.closeAllSnackbars();
                        await Future.delayed(Duration(milliseconds: 300));
                      }
                      Get.back();
                    }
                  },
                ),
        );
      }),
    );
  }
}
