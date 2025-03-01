import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/presentation/screens/home/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../_core/constants/typography.dart';
import '../../controllers/navigation_controller.dart';
import '../boarding_pass/pages/boarding_pass_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final int initialTabIndex;

  const MainNavigation({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final NavigationController navigationController = Get.find<NavigationController>();

  @override
  void initState() {
    super.initState();
    navigationController.currentPage.value = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            final List<Widget> pages = [
              HomeScreen(),
              BoardingPassScreen(),
              ProfileScreen(),
            ];
            return IndexedStack(
              index: navigationController.currentPage.value,
              children: pages,
            );
          }),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return BottomAppBar(
          color: Colors.white,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _bottomAppBarItem(
                    context,
                    iconPath: navigationController.currentPage.value == 0
                        ? 'assets/icons/ic_home_filled.svg'
                        : 'assets/icons/ic_home.svg',
                    page: 0,
                    label: 'Home',
                  ),
                ),
                Expanded(
                  child: _bottomAppBarItem(
                    context,
                    iconPath: navigationController.currentPage.value == 1
                        ? 'assets/icons/ic_boarding_pass_filled.svg'
                        : 'assets/icons/ic_boarding_pass.svg',
                    page: 1,
                    label: 'Boarding Pass',
                  ),
                ),
                Expanded(
                  child: _bottomAppBarItem(
                    context,
                    iconPath: navigationController.currentPage.value == 2
                        ? 'assets/icons/ic_profile_filled.svg'
                        : 'assets/icons/ic_profile.svg',
                    page: 2,
                    label: 'Profil',
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _bottomAppBarItem(
    BuildContext context, {
    required String iconPath,
    required int page,
    required String label,
  }) {
    final controller = Get.find<NavigationController>();
    final isActive = controller.currentPage.value == page;

    return ZoomTapAnimation(
      onTap: () => controller.goToTab(page),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24.w,
              height: 24.h,
            ),
            SizedBox(height: 4.h),
            TypographyStyles.caption(
              label,
              color: isActive ? PrimaryColors.primary800 : GrayColors.gray400,
              letterSpacing: 0.2,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
