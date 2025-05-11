import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_outline.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InformationUsersScreen extends StatefulWidget {
  const InformationUsersScreen({super.key});

  @override
  State<InformationUsersScreen> createState() => _InformationUsersScreenState();
}

class _InformationUsersScreenState extends State<InformationUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Informasi Biodata',
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
              child: Column(
                children: [
                  _buildHeaderInformation(),
                  _buildCardMain(),
                  _buildCardSecondary(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        child: ButtonOutline(
          text: 'Hapus Akun',
          textColor: RedColors.red600,
          borderColor: RedColors.red600,
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildHeaderInformation() {
    return Row(
      children: [
        Icon(
          Icons.info_outline_rounded,
          color: GrayColors.gray500,
          size: 24.sp,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: TypographyStyles.caption(
              'Semua informasi mengenai data diri Anda, akan ditampilkan di halaman ini. Lengkapi data diri anda untuk menikmati semua layanan E-Porter',
              color: GrayColors.gray500,
              maxlines: 5,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCardMain() {
    return Padding(
      padding: EdgeInsets.only(top: 32.h),
      child: CustomeShadowCotainner(
        child: Column(
          children: [
            itemWithButton(label: 'Nomor Telepon', value: 'value'),
            SizedBox(height: 24.h),
            itemWithButton(label: 'Email', value: 'ahmadzaqi98mmmmmm@gmail.com'),
            SizedBox(height: 24.h),
            itemDoubleWithButton(label1: 'Tipe ID', value2: 'value', label2: 'No ID', value1: 'value'),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSecondary() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: CustomeShadowCotainner(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            itemWithButton(label: 'Nama Lengkap', value: 'Ahmad Zaqi', isDivider: false),
            SizedBox(height: 24.h),
            Row(
              children: [
                infoDoubleItem(label: 'Jenis Kelamin', value: 'value'),
                SizedBox(width: 20.w),
                infoDoubleItem(label: 'Tanggal Lahir', value: 'value'),
              ],
            ),
            SizedBox(height: 24.h),
            infoDoubleItem(label: 'Alamat', value: 'value'),
            SizedBox(height: 24.h),
            infoDoubleItem(label: 'Kota / Kabupaten', value: 'value'),
            SizedBox(height: 24.h),
            infoDoubleItem(label: 'Pekerjaan', value: 'value')
          ],
        ),
      ),
    );
  }

  Widget itemWithButton({required String label, required String value, bool isDivider = true}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypographyStyles.body(label, fontWeight: FontWeight.w400, color: GrayColors.gray500),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: TypographyStyles.body(
                      value,
                      fontWeight: FontWeight.w500,
                      color: GrayColors.gray800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: PrimaryColors.primary100,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit, color: PrimaryColors.primary800, size: 14.sp),
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: TypographyStyles.small('Ubah', color: PrimaryColors.primary800),
                  ),
                ],
              ),
            )
          ],
        ),
        if (isDivider)
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Divider(thickness: 1, color: GrayColors.gray200),
          )
      ],
    );
  }

  Widget itemDoubleWithButton({
    required String label1,
    required String label2,
    required String value1,
    required String value2,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            infoDoubleItem(label: label1, value: value1),
            SizedBox(width: 20.w),
            infoDoubleItem(label: label2, value: value2)
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: PrimaryColors.primary100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Icon(Icons.edit, color: PrimaryColors.primary800, size: 14.sp),
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: TypographyStyles.small('Ubah', color: PrimaryColors.primary800),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget infoDoubleItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TypographyStyles.body(label, fontWeight: FontWeight.w400, color: GrayColors.gray500),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: TypographyStyles.body(value, fontWeight: FontWeight.w500, color: GrayColors.gray800),
        ),
      ],
    );
  }
}
