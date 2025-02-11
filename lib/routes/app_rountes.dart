import 'package:e_porter/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:e_porter/presentation/screens/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => OnboardingScreen(),
    ),
  ];
}

class Routes {
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
}
