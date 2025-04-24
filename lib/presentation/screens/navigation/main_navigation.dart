import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/presentation/screens/boarding_pass/pages/history_porter_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../_core/constants/typography.dart';
import '../../controllers/navigation_controller.dart';
import '../boarding_pass/pages/boarding_pass_screen.dart';
import '../profile/pages/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final int initialTabIndex;

  const MainNavigation({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final NavigationController navigationController = Get.find<NavigationController>();
  late final String role;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    role = Get.arguments as String? ?? 'penumpang';
    navigationController.currentPage.value = widget.initialTabIndex;

    pages = [
      HomeScreen(),
      if (role == 'penumpang') BoardingPassScreen() else HistoryPorterScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool isPassenger = role == 'penumpang';

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            // Dapatkan nilai dari currentPage
            int pageIndex = navigationController.currentPage.value;

            // Pastikan nilai valid
            if (pageIndex < 0 || pageIndex >= pages.length) {
              pageIndex = 0;
            }

            return IndexedStack(
              index: pageIndex,
              children: pages,
            );
          })
        ],
      ),
      bottomNavigationBar: Obx(() {
        // final current = navigationController.currentPage.value;
        int current = navigationController.currentPage.value;

        return BottomAppBar(
          color: Colors.white,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  iconActive: 'assets/icons/ic_home_filled.svg',
                  iconInactive: 'assets/icons/ic_home.svg',
                  label: 'Home',
                  page: 0,
                  current: current,
                ),
                _buildNavItem(
                  iconActive:
                      isPassenger ? 'assets/icons/ic_boarding_pass_filled.svg' : 'assets/icons/ic_scroll_filled.svg',
                  iconInactive:
                      isPassenger ? 'assets/icons/ic_boarding_pass.svg' : 'assets/icons/ic_scroll_outline.svg',
                  label: isPassenger ? 'Boarding Pass' : 'Riwayat',
                  page: 1,
                  current: current,
                ),
                _buildNavItem(
                  iconActive: 'assets/icons/ic_profile_filled.svg',
                  iconInactive: 'assets/icons/ic_profile.svg',
                  label: 'Profil',
                  page: 2,
                  current: current,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNavItem({
    required String iconActive,
    required String iconInactive,
    required String label,
    required int page,
    required int current,
  }) {
    final isActive = current == page;
    return Expanded(
      child: ZoomTapAnimation(
        onTap: () => navigationController.goToTab(page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isActive ? iconActive : iconInactive,
              width: 24.w,
              height: 24.h,
            ),
            SizedBox(height: 4.h),
            TypographyStyles.caption(
              label,
              color: isActive ? PrimaryColors.primary800 : GrayColors.gray400,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
