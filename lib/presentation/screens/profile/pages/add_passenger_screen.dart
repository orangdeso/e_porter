import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/text_field/dropdown/dropdown_component.dart';
import 'package:e_porter/_core/component/text_field/text_input/text_field_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddPassengerScreen extends StatefulWidget {
  const AddPassengerScreen({super.key});

  @override
  State<AddPassengerScreen> createState() => _AddPassengerScreenState();
}

class _AddPassengerScreenState extends State<AddPassengerScreen> {
  final ValueNotifier<String> selectedGender = ValueNotifier<String>('');

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
                TextFieldComponent(hintText: 'Masukkan nama lengkap'),
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
                          value: "KTP",
                          onChanged: (value) {},
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
                          TextFieldComponent(hintText: 'Masukkan ID')
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
      bottomNavigationBar: CustomeShadowCotainner(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        borderRadius: BorderRadius.circular(0.r),
        child: ButtonFill(
          text: 'Simpan',
          textColor: Colors.white,
          onTap: () {},
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
}
