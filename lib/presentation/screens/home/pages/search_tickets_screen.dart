// ignore_for_file: unnecessary_null_comparison

import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/home/component/card_tickets.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../_core/service/logger_service.dart';
import '../../../controllers/ticket_controller.dart';

class SearchTicketsScreen extends StatefulWidget {
  const SearchTicketsScreen({super.key});

  @override
  State<SearchTicketsScreen> createState() => _SearchTicketsScreenState();
}

class _SearchTicketsScreenState extends State<SearchTicketsScreen> {
  late final TicketController ticketController;
  late final String from;
  late final String to;
  late final DateTime leavingDate;
  late final String flightClass;
  late final int passengerCount;

  @override
  void initState() {
    super.initState();

    // Ambil parameter yang dikirim dari BookingTickets
    final args = Get.arguments as Map<String, dynamic>;
    from = args['from'];
    to = args['to'];
    leavingDate = args['leavingDate'];
    flightClass = args['flightClass'] ?? '';
    passengerCount = args['passengerCount'] ?? 1;

    ticketController = Get.find<TicketController>();

    ticketController.searchTickets(
      from: from,
      to: to,
      leavingDate: leavingDate,
      flightClass: flightClass,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEE, d MMM yyyy').format(leavingDate);
    final currencyFormatter = NumberFormat.decimalPattern('id_ID');

    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: CustomeAppbarComponent(
        valueDari: from,
        valueKe: to,
        date: '$formattedDate',
        passenger: '$passengerCount',
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypographyStyles.h6(
                'Pilih Pesawat',
                color: GrayColors.gray800,
                letterSpacing: 0.2,
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Obx(() {
                  if (ticketController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (ticketController.ticketFlight.isEmpty) {
                    return Center(
                      child: TypographyStyles.body(
                        "Tiket tidak ditemukan",
                        color: GrayColors.gray600,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: ticketController.ticketFlight.length,
                      itemBuilder: (context, index) {
                        final item = ticketController.ticketFlight[index];
                        final ticket = item.ticket;
                        final flight = item.flight;

                        final ticketDate = DateFormat("EEE, d MMM").format(ticket.leavingDate);
                        final departureTime = DateFormat.jm().format(flight.departureTime);
                        final arrivalTime = DateFormat.jm().format(flight.arrivalTime);
                        final formattedPrice = 'Rp ${currencyFormatter.format(flight.price)}';

                        Duration diff = flight.arrivalTime.difference(flight.departureTime);
                        if (diff.isNegative) {
                          diff = diff + Duration(days: 1);
                        }
                        final hours = diff.inHours;
                        final minutes = diff.inMinutes % 60;
                        final duration = '${hours}j ${minutes}m';

                        String stopText = '';
                        if (flight.stop != null && flight.stop.isNotEmpty) {
                          stopText = '${flight.stop} - ';
                        }
                        final finalDuration = '$stopText$duration';
                        final ticketId = '${ticket.id}';
                        final flightId = '${flight.id}';

                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: CardTickets(
                            departureCity: '${flight.cityDeparture} (${flight.codeDeparture})',
                            date: ticketDate,
                            arrivalCity: '${flight.cityArrival} (${flight.codeArrival})',
                            departureCode: '${flight.codeDeparture}',
                            arrivalCode: '${flight.codeArrival}',
                            departureTime: departureTime,
                            arrivalTime: arrivalTime,
                            duration: finalDuration,
                            seatClass: flight.flightClass,
                            price: formattedPrice,
                            onTap: () {
                              final argument = {
                                "ticketId": ticketId,
                                "flightId": flightId,
                                "ticketDate": ticketDate,
                                "passenger": passengerCount,
                              };
                              logger.d(
                                  'ID Ticket: $ticketId \nID Flight: $flightId \nTicket Date: $ticketDate \nPassenger: $passengerCount');
                              Get.toNamed(Routes.TICKETBOOKINGSTEP1, arguments: argument);
                            },
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
