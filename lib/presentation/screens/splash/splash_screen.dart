
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    Future.delayed(Duration(seconds: 3), () async {
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
      body: Center(
        child: Text(
          'Splash Screen',
          style: TextStyle(
            fontSize: 32.sp,
          ),
        ),
      ),
    );
  }
}
