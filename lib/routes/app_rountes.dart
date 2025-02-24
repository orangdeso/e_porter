import 'package:e_porter/domain/bindings/search_flight_binding.dart';
import 'package:e_porter/presentation/screens/auth/pages/forget_password_screen.dart';
import 'package:e_porter/presentation/screens/auth/pages/login_screen.dart';
import 'package:e_porter/presentation/screens/auth/pages/register_screen.dart';
import 'package:e_porter/presentation/screens/auth/pages/state_succes_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/booking_tickets.dart';
import 'package:e_porter/presentation/screens/home/pages/choose_chair_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/home_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/search_flight_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/search_tickets_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/ticket_booking_step1_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/ticket_booking_step2_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/ticket_booking_step3_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/ticket_booking_step4_screen.dart';
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
    GetPage(
      name: Routes.SEARCHFLIGHT,
      page: () => SearchFlightScreen(),
      binding: SearchFlightBinding(),
    ),
    GetPage(
      name: Routes.SEARCHTICKETS,
      page: () => SearchTicketsScreen(),
    ),
    GetPage(
      name: Routes.TICKETBOOKINGSTEP1,
      page: () => TicketBookingStep1Screen(),
    ),
    GetPage(
      name: Routes.TICKETBOOKINGSTEP2,
      page: () => TicketBookingStep2Screen(),
    ),
    GetPage(
      name: Routes.TICKETBOOKINGSTEP3,
      page: () => TicketBookingStep3Screen(),
    ),
    GetPage(
      name: Routes.TICKETBOOKINGSTEP4,
      page: () => TicketBookingStep4Screen(),
    ),
    GetPage(
      name: Routes.CHOOSECHAIR,
      page: () => ChooseChairScreen(),
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
  static const SEARCHFLIGHT = '/search_flight';
  static const SEARCHTICKETS = '/search_tickets';
  static const TICKETBOOKINGSTEP1 = '/ticket_booking_step1';
  static const TICKETBOOKINGSTEP2 = '/ticket_booking_step2';
  static const TICKETBOOKINGSTEP3 = '/ticket_booking_step3';
  static const TICKETBOOKINGSTEP4 = '/ticket_booking_step4';
  static const CHOOSECHAIR = '/choose_chair';
}
