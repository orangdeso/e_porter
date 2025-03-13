import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/text_field/dropdown/dropdown_component.dart';
import 'package:e_porter/_core/component/text_field/text_input/text_field_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/_core/utils/snackbar/snackbar_helper.dart';
import 'package:e_porter/_core/validators/validators.dart';
import 'package:e_porter/presentation/controllers/profil_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../_core/service/logger_service.dart';
import '../../../../_core/service/preferences_service.dart';
import '../../../../_core/utils/firestore/unique_helper.dart';
import '../../../../_core/utils/formatter/uppercase_helper.dart';

class AddPassengerScreen extends StatefulWidget {
  const AddPassengerScreen({super.key});

  @override
  State<AddPassengerScreen> createState() => _AddPassengerScreenState();
}

class _AddPassengerScreenState extends State<AddPassengerScreen> {
  final ValueNotifier<String> selectedGender = ValueNotifier<String>('Laki-laki');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noIdController = TextEditingController();
  final ProfilController profilController = Get.find<ProfilController>();
  final _formKey = GlobalKey<FormState>();

  String selectedTypeId = 'KTP';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        backgroundColors: PrimaryColors.primary800,
        title: "Tambah Penumpang",
        textColor: Colors.white,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypographyStyles.body(
                    "Silahkan isi informasi data diri calon penumpang baru",
                    color: GrayColors.gray600,
                    fontWeight: FontWeight.w400,
                    maxlines: 2,
                  ),
                  SizedBox(height: 32.h),
                  TypographyStyles.body('Nama Lengkap', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                  SizedBox(height: 16.w),
                  TextFieldComponent(
                    controller: _nameController,
                    hintText: 'Masukkan nama lengkap',
                    validators: Validators.validatorName,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                      UpperCaseTextFormatter(),
                    ],
                    textInputType: TextInputType.text,
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
                  SizedBox(height: 20.w),
                  TypographyStyles.body('Jenis Kelamin', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                  Row(
                    children: [
                      _buildRadioButton(context, label: 'Laki-laki', value: 'Laki-laki'),
                      SizedBox(width: 40.h),
                      _buildRadioButton(context, label: 'Perempuan', value: 'Perempuan')
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        borderRadius: BorderRadius.circular(0.r),
        child: ButtonFill(
          text: 'Simpan',
          textColor: Colors.white,
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              _onSavePassenger();
            }
          },
        ),
      ),
    );
  }

  Widget _buildRadioButton(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedGender,
      builder: (context, selected, child) {
        return Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: selected,
              activeColor: PrimaryColors.primary800,
              onChanged: (val) {
                selectedGender.value = val!;
              },
            ),
            SizedBox(width: 10.w),
            TypographyStyles.body(label, color: GrayColors.gray800, fontWeight: FontWeight.w500)
          ],
        );
      },
    );
  }

  Future<void> _onSavePassenger() async {
    final name = _nameController.text.trim();
    final noId = _noIdController.text.trim();
    final gender = selectedGender.value;
    final typeId = selectedTypeId;

    if (name.isEmpty || noId.isEmpty) {
      Get.snackbar('Error', 'Nama dan No ID tidak boleh kosong');
      return;
    }

    try {
      final userData = await PreferencesService.getUserData();
      if (userData == null || userData.uid.isEmpty) {
        SnackbarHelper.showInfo('Error', 'User ID tidak ditemukan, silakan login kembali');
        return;
      }
      final userId = userData.uid;

      final bool isUnique = await isNoIdUnique(userId, noId);
      if (!isUnique) {
        SnackbarHelper.showError('Error', 'No ID sudah digunakan. Harap gunakan No ID yang berbeda');
        return;
      }

      await profilController.addPassenger(
        userId: userId,
        typeId: typeId,
        noId: noId,
        name: name,
        gender: gender,
      );
      _nameController.clear();
      _noIdController.clear();

      SnackbarHelper.showSuccess('Sukses', 'Berhasil menambahkan penumpang baru');
      logger.d("Berhasil menambah penumpang: {name: $name, typeId: $typeId, noId: $noId, gender: $gender}");
    } catch (e) {
      SnackbarHelper.showError('Error', 'Gagal menambahkan penumpang baru: $e');
      logger.e("Gagal menambah penumpang: $e");
    }
  }
}
