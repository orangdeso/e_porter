import 'dart:developer';

import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../_core/component/button/button_fill.dart';
import '../../../../_core/service/logger_service.dart';
import '../../../../domain/models/porter_service_model.dart';
import '../../../../domain/models/ticket_model.dart';
import '../../../../domain/models/user_entity.dart';
import '../../../controllers/ticket_controller.dart';
import '../../routes/app_rountes.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final String ticketId;
  late final String flightId;
  late String? ticketDate;
  late final int passenger;
  late final List<PassengerModel?> selectedPassengers;
  late List<String> numberSeat;
  late List<String> selectedServiceLabels;
  late Map<String, PorterServiceModel?> selectedPorterServices;
  late double totalPrice;
  late double grandTotal;
  late double totalAll;
  late String expiryTime;

  final TicketController ticketController = Get.find<TicketController>();
  FlightModel? flightData;
  String? departureTime;
  String? arrivalTime;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    ticketId = args['ticketId'] ?? '';
    flightId = args['flightId'] ?? '';
    ticketDate = args['date'];
    passenger = args['passenger'] ?? 0;
    selectedPassengers = args['selectedPassenger'] ?? [];
    numberSeat = args['numberSeat'] ?? '';
    totalPrice = args['totalPrice'] ?? 0.0;
    grandTotal = args['grandTotal'] ?? 0.0;
    totalAll = args['totalAll'] ?? 0.0;
    selectedServiceLabels = args['selectedServiceLabels'] ?? [];
    selectedPorterServices = args['selectedPorterServices'] ?? {};
    expiryTime = args['expiryTime'] ?? '';

    fetchDataFlight();
  }

  Future<void> fetchDataFlight() async {
    try {
      FlightModel flight = await ticketController.getFlightById(ticketId: ticketId, flightId: flightId);
      setState(() {
        flightData = flight;
      });
    } catch (e) {
      logger.e('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Kode QRIS',
        textColor: Colors.white,
        backgroundColors: PrimaryColors.primary800,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TypographyStyles.h5("E-Porter", color: GrayColors.gray800),
                  SizedBox(height: 10.h),
                  TypographyStyles.body(
                    "${flightData?.airLines} (${flightData?.code})",
                    color: GrayColors.gray800,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 16.h),
                  TypographyStyles.h5(
                    "Rp ${NumberFormat.decimalPattern('id_ID').format(totalAll)}",
                    color: GrayColors.gray800,
                  ),
                  SizedBox(height: 32.h),
                  SvgPicture.asset('assets/images/qris.svg'),
                  SizedBox(height: 20.h),
                  TypographyStyles.small(
                    "Berlaku hingga : $expiryTime",
                    color: GrayColors.gray600,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        child: ButtonFill(
          text: 'Lanjutkan',
          textColor: Colors.white,
          onTap: () {
            final argument = {
              'ticketId': ticketId,
              'transactionId': Get.arguments['transactionId'],
              'flightData': flightData,
              'totalAll': totalAll,
            };
            log('Transaction ID: $argument');
            Get.toNamed(Routes.UPLOADFILE, arguments: argument);
          },
        ),
      ),
    );
  }
}
