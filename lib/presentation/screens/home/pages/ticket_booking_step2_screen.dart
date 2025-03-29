import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/domain/models/user_entity.dart';
import 'package:e_porter/presentation/controllers/ticket_controller.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/button/button_fill.dart';
import '../../../../_core/constants/typography.dart';
import '../component/card_flight_information.dart';

class TicketBookingStep2Screen extends StatefulWidget {
  const TicketBookingStep2Screen({super.key});

  @override
  State<TicketBookingStep2Screen> createState() => _TicketBookingStep2ScreenState();
}

class _TicketBookingStep2ScreenState extends State<TicketBookingStep2Screen> {
  late final TicketController ticketController;
  late final String ticketId;
  late final String flightId;
  String? ticketDate;
  String? departureTime;
  String? arrivalTime;
  String? cityDeparture;
  String? cityArrival;
  String? airLines;
  String? code;
  String? flightClass;
  String? transitAirplane;
  String? stop;
  String? codeDeparture;
  String? codeArrival;
  String? airlineLogo;
  late final int passenger;
  late final List<PassengerModel?> selectedPassengers;
  late List<String> selectedSeatNumbers;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    ticketId = args['ticketId'];
    flightId = args['flightId'];
    ticketDate = args['date'];
    departureTime = args['departureTime'];
    arrivalTime = args['arrivalTime'];
    cityDeparture = args['cityDeparture'];
    cityArrival = args['cityArrival'];
    airLines = args['airLines'];
    code = args['code'];
    flightClass = args['flightClass'];
    transitAirplane = args['transitAirplane'];
    stop = args['stop'];
    codeDeparture = args['codeDeparture'];
    codeArrival = args['codeArrival'];
    airlineLogo = args['airlineLogo'] ?? '';
    passenger = args['passenger'];
    selectedPassengers = args['selectedPassenger'] ?? [];
    selectedSeatNumbers = args['selectedSeatNumbers'] ?? List.filled(passenger, '');

    // logger.d('Ticket ID: $ticketId \nFlight ID: $flightId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: ProgressAppbarComponent(
        title: 'Pesan Tiket',
        subTitle: 'Langkah 2 dari 4',
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardFlightInformation(
                  date: '$ticketDate',
                  time: '${departureTime} - ${arrivalTime}',
                  departureCity: '$cityDeparture',
                  arrivalCity: '$cityArrival',
                  plane: '${airLines} (${code})',
                  seatClass: '$flightClass',
                  passenger: '$passenger',
                  transiAirplane: '$transitAirplane',
                  stop: '$stop',
                  airlineLogo: airlineLogo,
                ),
                SizedBox(height: 32.h),
                TypographyStyles.h6('Pilih Kursi', color: GrayColors.gray800),
                SizedBox(height: 4.h),
                ...List.generate(
                  passenger,
                  (index) {
                    final passengerData = selectedPassengers[index];
                    return Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: _buildCardSeatPessenger(
                        context,
                        label: '${index + 1}',
                        namePassenger: passengerData?.name ?? 'Unknown Passenger',
                        seatClass: '$flightClass',
                        numberSeat: '${selectedSeatNumbers[index].isEmpty ? '-' : selectedSeatNumbers[index]}',
                        onTap: () async {
                          final argument = {
                            'ticketId': ticketId,
                            'flightId': flightId,
                            'passenger': passenger,
                            'selectedPassenger': selectedPassengers,
                          };
                          final result = await Get.toNamed(Routes.CHOOSECHAIR, arguments: argument);
                          if (result != null && result is List<String>) {
                            setState(() {
                              selectedSeatNumbers = result;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: ZoomTapAnimation(
          child: ButtonFill(
            text: 'Lanjutkan',
            textColor: Colors.white,
            backgroundColor:
                selectedSeatNumbers.any((seat) => seat.isEmpty) ? GrayColors.gray400 : PrimaryColors.primary800,
            onTap: selectedSeatNumbers.any((seat) => seat.isEmpty)
                ? null
                : () {
                    final argument = {
                      'ticketId': ticketId,
                      'flightId': flightId,
                      'date': ticketDate,
                      'passenger': passenger,
                      'selectedPassenger': selectedPassengers,
                      'numberSeat': selectedSeatNumbers
                    };
                    // logger.d('Number Seat: $selectedSeatNumbers \n Passenger: $selectedPassengers');
                    Get.toNamed(Routes.TICKETBOOKINGSTEP3, arguments: argument);
                  },
          ),
        ),
      ),
    );
  }

  Widget _buildCardSeatPessenger(
    BuildContext context, {
    required String label,
    required String namePassenger,
    required String seatClass,
    required String numberSeat,
    required VoidCallback onTap,
  }) {
    return CustomeShadowCotainner(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypographyStyles.caption(
                'Penumpang ${label} (Dewasa)',
                color: GrayColors.gray600,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
              SizedBox(height: 2.h),
              TypographyStyles.body(
                namePassenger,
                color: GrayColors.gray800,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
                maxlines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              TypographyStyles.caption(
                '${seatClass} / ${numberSeat}',
                color: GrayColors.gray600,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              )
            ],
          ),
          ZoomTapAnimation(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5.w, color: PrimaryColors.primary800),
                  borderRadius: BorderRadius.circular(35.r),
                ),
                child: TypographyStyles.caption(
                  'Pilih Kursi',
                  color: PrimaryColors.primary800,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
