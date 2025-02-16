import 'package:e_porter/presentation/screens/auth/pages/forget_password_screen.dart';
import 'package:e_porter/presentation/screens/auth/pages/login_screen.dart';
import 'package:e_porter/presentation/screens/auth/pages/register_screen.dart';
import 'package:e_porter/presentation/screens/auth/pages/state_succes_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/booking_tickets.dart';
import 'package:e_porter/presentation/screens/home/pages/home_screen.dart';
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
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: Routes.FORGETPASSWORD,
      page: () => ForgetPasswordScreen(),
    ),
    GetPage(
      name: Routes.STATESUCCES,
      page: () => StateSuccesScreen(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: Routes.BOOKINGTICKETS,
      page: () => BookingTickets(),
    ),
  ];
}

class Routes {
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGETPASSWORD = '/forget_password';
  static const STATESUCCES = '/state_succes';
  static const HOME = '/home';
  static const BOOKINGTICKETS = '/booking_tickets';
}
