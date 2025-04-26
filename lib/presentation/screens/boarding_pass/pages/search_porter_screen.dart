import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../_core/component/appbar/appbar_component.dart';
import '../../../../_core/constants/colors.dart';

class ProcessingPorterScreen extends StatefulWidget {
  const ProcessingPorterScreen({Key? key}) : super(key: key);

  @override
  State<ProcessingPorterScreen> createState() => _ProcessingPorterScreenState();
}

class _ProcessingPorterScreenState extends State<ProcessingPorterScreen> {
  @override
  void initState() {
    super.initState();
    // final args = Get.arguments as Map<String, dynamic>;
    // final location = args['location'] ?? '';
    // final ticketId = args['ticketId'] ?? '';
    // final transactionId = args['transactionId'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Mencari Porter',
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
            child: Column(
              children: [
                TypographyStyles.h1('Ilustrasi'),
                SizedBox(height: 32.h),
                CustomeShadowCotainner(
                  child: Column(
                    children: [
                      TypographyStyles.h6('Tunggu Portermu', color: GrayColors.gray800),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TypographyStyles.caption(
                            'Tunngu dari pihak Porter merespon',
                            color: GrayColors.gray500,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(width: 4.w),
                          Icon(Icons.timelapse_outlined)
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                CustomeShadowCotainner(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TypographyStyles.body('Ahmad Choirul Umam', color: GrayColors.gray800),
                      SizedBox(height: 10.h),
                      Divider(thickness: 1, color: GrayColors.gray200),
                      SizedBox(height: 10.h),
                      TypographyStyles.body('Lokasi', color: GrayColors.gray800),
                      SizedBox(height: 10.h),
                      _buildRowLocation(location: 'Gate Penerbangan', desc: 'Lokasi Anda'),
                      SizedBox(height: 10.h),
                      _buildRowLocation(location: 'Guyangan', desc: 'Lokasi Porter Anda'),
                      SizedBox(height: 10.h),
                      _buildRowLocation(location: 'Porter menuju ke lokasi anda', desc: 'Porter bergerak'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        child: ButtonFill(
          text: 'Kembali ke menu',
          textColor: Colors.white,
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildRowLocation({required String location, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TypographyStyles.caption(
              '10/10/2025',
              color: GrayColors.gray600,
              fontWeight: FontWeight.w400,
            ),
            TypographyStyles.caption(
              '11:11',
              color: GrayColors.gray600,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        SizedBox(width: 20.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TypographyStyles.caption(
              location,
              color: GrayColors.gray800,
              fontWeight: FontWeight.w600,
            ),
            TypographyStyles.small(
              desc,
              color: GrayColors.gray600,
              fontWeight: FontWeight.w400,
            )
          ],
        ),
      ],
    );
  }
}
