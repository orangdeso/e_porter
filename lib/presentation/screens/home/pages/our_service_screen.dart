import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/appbar/appbar_component.dart';
import '../../../../data/resource/service_data.dart';

class OurServiceScreen extends StatefulWidget {
  const OurServiceScreen({super.key});

  @override
  State<OurServiceScreen> createState() => _OurServiceScreenState();
}

class _OurServiceScreenState extends State<OurServiceScreen> {
  int selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = Get.arguments ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Layanan Kami',
        backgroundColors: Colors.white,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCardButton(
                    context,
                    text: 'Fast Track',
                    isSelected: selectedIndex == 0,
                    onTap: () => _onTabSelected(0),
                  ),
                  SizedBox(width: 16.w),
                  _buildCardButton(
                    context,
                    text: 'Porter VIP',
                    isSelected: selectedIndex == 1,
                    onTap: () => _onTabSelected(1),
                  ),
                  SizedBox(width: 16.w),
                  _buildCardButton(
                    context,
                    text: 'Transit',
                    isSelected: selectedIndex == 2,
                    onTap: () => _onTabSelected(2),
                  )
                ],
              ),
              SizedBox(height: 32.h),
              Divider(thickness: 1, color: GrayColors.gray200),
              SizedBox(height: 32.h),
              TypographyStyles.body(ServiceData.titles[selectedIndex], color: GrayColors.gray800),
              SizedBox(height: 6.h),
              TypographyStyles.caption(
                ServiceData.descriptions[selectedIndex],
                color: GrayColors.gray600,
                fontWeight: FontWeight.w400,
                maxlines: 14,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardButton(
    BuildContext context, {
    required String text,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 114.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? PrimaryColors.primary100 : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(width: 1.w, color: isSelected ? PrimaryColors.primary800 : GrayColors.gray500),
          ),
          child: Center(
              child: TypographyStyles.body(text, color: isSelected ? PrimaryColors.primary800 : GrayColors.gray500)),
        ),
      ),
    );
  }
}
