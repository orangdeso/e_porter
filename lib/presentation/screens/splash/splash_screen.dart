import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:e_porter/presentation/widgets/animations/fade_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../_core/service/preferences_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 3), () async {
    //   final userData = await PreferencesService.getUserData();
    //   if (userData != null) {
    //     Get.offAllNamed(Routes.NAVBAR, arguments: userData.role);
    //   } else {
    //     Get.offAllNamed(Routes.ONBOARDING);
    //   }
    // });
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () async {
      final userData = await PreferencesService.getUserData();
      if (userData != null) {
        Get.offAllNamed(Routes.NAVBAR, arguments: userData.role);
      } else {
        Get.offAllNamed(Routes.ONBOARDING);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeSlideAnimation(
          duration: const Duration(milliseconds: 1200),
          delay: const Duration(milliseconds: 300),
          slideOffset: const Offset(0, 0.3),
          curve: Curves.easeOutBack,
          enableScale: true,
          enableBlur: true,
          scaleBegin: 0.2, 
          scaleEnd: 1.0,
          child: SvgPicture.asset(
            'assets/images/eporter-logo.svg',
          ),
        ),
      ),
    );
  }
}
