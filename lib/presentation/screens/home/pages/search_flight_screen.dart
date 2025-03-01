import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/search_bar/search_bar_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/controllers/search_flight_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SearchFlightScreen extends StatefulWidget {
  const SearchFlightScreen({super.key});

  @override
  State<SearchFlightScreen> createState() => _SearchFlightScreenState();
}

class _SearchFlightScreenState extends State<SearchFlightScreen> {
  final controller = Get.find<SearchFlightController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Cari Lokasi Bandara',
        backgroundColors: Colors.white,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            children: [
              SearchBarComponent(hintText: 'Cari Bandara'),
              SizedBox(height: 20.h),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(strokeAlign: 1, color: GrayColors.gray100),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Obx(() {
                    final airports = controller.airports;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: airports.length,
                      itemBuilder: (context, index) {
                        final airport = airports[index];
                        return _buildCardItem(
                          '${airport.code} - ${airport.city}',
                          '${airport.name}',
                          () {},
                        );
                      },
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardItem(
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ZoomTapAnimation(
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            title: TypographyStyles.body(
              title,
              fontWeight: FontWeight.bold,
              color: GrayColors.gray800,
            ),
            subtitle: TypographyStyles.caption(
              subtitle,
              fontWeight: FontWeight.w400,
              color: GrayColors.gray500,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(
              thickness: 1,
              color: GrayColors.gray200,
            ),
          ),
        ],
      ),
    );
  }
}
