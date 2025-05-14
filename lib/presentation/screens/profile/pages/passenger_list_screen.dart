// ignore_for_file: deprecated_member_use
import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class PassengerListScreen extends StatefulWidget {
  const PassengerListScreen({super.key});

  @override
  State<PassengerListScreen> createState() => _PassengerListScreenState();
}

class _PassengerListScreenState extends State<PassengerListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Daftar Penumpang',
        textColor: Colors.white,
        backgroundColors: PrimaryColors.primary800,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildCardItem(
                    value: 'Name',
                    onTap: () {
                      // Get.toNamed(Routes.passengerDetail);
                    },
                  ),
                );
              },
            )),
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        child: ButtonFill(
          text: 'Tambah Penumpang',
          textColor: Colors.white,
          onTap: () {
            Get.toNamed(Routes.ADDPASSENGER);
          },
        ),
      ),
    );
  }

  Widget _buildCardItem({required String value, required VoidCallback onTap}) {
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: GrayColors.gray200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypographyStyles.caption('Dewasa', fontWeight: FontWeight.w400, color: GrayColors.gray500),
                  TypographyStyles.body(value, color: GrayColors.gray800)
                ],
              ),
              SvgPicture.asset(
                'assets/icons/ic_more_than.svg',
                color: GrayColors.gray500,
                width: 20.w,
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
