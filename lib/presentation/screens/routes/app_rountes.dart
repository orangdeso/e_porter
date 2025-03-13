import 'package:e_porter/domain/bindings/auth_binding.dart';
import 'package:e_porter/domain/bindings/navigation_binding.dart';
import 'package:e_porter/domain/bindings/profil_binding.dart';
import 'package:e_porter/domain/bindings/search_flight_binding.dart';
import 'package:e_porter/domain/bindings/ticket_binding.dart';
import 'package:e_porter/presentation/screens/auth/pages/forget_password_screen.dart';
import 'package:e_porter/presentation/screens/auth/pages/login_screen.dart';
import 'package:e_porter/presentation/screens/auth/pages/register_screen.dart';
import 'package:e_porter/presentation/screens/auth/pages/state_succes_screen.dart';
import 'package:e_porter/presentation/screens/boarding_pass/pages/boarding_pass_screen.dart';
import 'package:e_porter/presentation/screens/boarding_pass/pages/transaction_history.dart';
import 'package:e_porter/presentation/screens/home/pages/booking_tickets_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/choose_seat_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/payment_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/search_flight_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/search_tickets_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/ticket_booking_step1_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/ticket_booking_step2_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/ticket_booking_step3_screen.dart';
import 'package:e_porter/presentation/screens/home/pages/ticket_booking_step4_screen.dart';
import 'package:e_porter/presentation/screens/navigation/main_navigation.dart';
import 'package:e_porter/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:e_porter/presentation/screens/profile/pages/profile_screen.dart';
import 'package:e_porter/presentation/screens/profile/pages/add_passenger_screen.dart';
import 'package:e_porter/presentation/screens/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.NAVBAR,
      page: () => MainNavigation(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => OnboardingScreen(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => MainNavigation(),
    ),
    GetPage(
      name: Routes.BOARDINGPASS,
      page: () => BoardingPassScreen(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileScreen(),
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
      binding: TicketBinding(),
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
      page: () => ChooseSeatScreen(),
    ),
    GetPage(
      name: Routes.PAYMENT,
      page: () => PaymentScreen(),
    ),
    GetPage(
      name: Routes.TRANSACTIONHISTORY,
      page: () => transactionHistory(),
    ),
    GetPage(
      name: Routes.ADDPASSENGER,
      page: () => AddPassengerScreen(),
      binding: ProfilBinding(),
    ),
  ];
}

class Routes {
  static const NAVBAR = '/navigation';
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const BOARDINGPASS = '/boarding_pass';
  static const PROFILE = '/profile';
  static const REGISTER = '/register';
  static const FORGETPASSWORD = '/forget_password';
  static const STATESUCCES = '/state_succes';
  static const BOOKINGTICKETS = '/booking_tickets';
  static const SEARCHFLIGHT = '/search_flight';
  static const SEARCHTICKETS = '/search_tickets';
  static const TICKETBOOKINGSTEP1 = '/ticket_booking_step1';
  static const TICKETBOOKINGSTEP2 = '/ticket_booking_step2';
  static const TICKETBOOKINGSTEP3 = '/ticket_booking_step3';
  static const TICKETBOOKINGSTEP4 = '/ticket_booking_step4';
  static const CHOOSECHAIR = '/choose_chair';
  static const PAYMENT = '/payment';
  static const TRANSACTIONHISTORY = '/transaction_history';

  static const ADDPASSENGER = '/add_passenger';
}
