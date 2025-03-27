import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/home/component/footer_price.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../_core/component/appbar/appbar_component.dart';
import '../../../../_core/component/icons/icons_library.dart';
import '../../../../_core/service/logger_service.dart';
import '../../../../domain/models/porter_service_model.dart';
import '../../../../domain/models/ticket_model.dart';
import '../../../../domain/models/user_entity.dart';
import '../../../controllers/ticket_controller.dart';
import '../component/card_flight_information.dart';

class TicketBookingStep4Screen extends StatefulWidget {
  const TicketBookingStep4Screen({super.key});

  @override
  State<TicketBookingStep4Screen> createState() => _TicketBookingStep4ScreenState();
}

class _TicketBookingStep4ScreenState extends State<TicketBookingStep4Screen> {
  late final String ticketId;
  late final String flightId;
  late String? ticketDate;
  late final int passenger;
  late final List<PassengerModel?> selectedPassengers;
  late List<String> numberSeat;
  late List<String> selectedServiceLabels;
  late Map<String, PorterServiceModel?> selectedPorterServices;

  double? totalPrice;
  double? grandTotal;

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
    selectedServiceLabels = args['selectedServiceLabels'] ?? [];
    selectedPorterServices = args['selectedPorterServices'] ?? {};

    // log('Ticket ID Step 4: $ticketId');
    // log('Opsi Penerbangan Step 4: $selectedServiceLabels');

    // if (selectedServiceLabels.isNotEmpty) {
    //   log('Opsi Penerbangan Step 4: ${selectedServiceLabels.join(", ")}');
    // } else {
    //   log('Tidak ada opsi penerbangan yang dipilih');
    // }

    // selectedPorterServices.forEach((key, value) {
    //   if (value != null) {
    //     log('Porter $key: ${value.name} - Rp ${value.price}');
    //   }
    // });

    fetchDataFlight();
  }

  Future<void> fetchDataFlight() async {
    try {
      FlightModel flight = await ticketController.getFlightById(ticketId: ticketId, flightId: flightId);
      setState(() {
        flightData = flight;
        departureTime = DateFormat.jm().format(flightData!.departureTime);
        arrivalTime = DateFormat.jm().format(flightData!.arrivalTime);
      });
    } catch (e) {
      logger.e('Terjadi kesalahan: $e');
    }
  }

  String getPorterInfo(String type) {
    final porter = selectedPorterServices[type];
    if (porter != null) {
      return '${porter.name}';
    }
    return '';
  }

  String getPorterPrice(String type) {
    final porter = selectedPorterServices[type];
    if (porter != null) {
      try {
        return NumberFormat.decimalPattern('id_ID').format(porter.price);
      } catch (e) {
        print("Error formatting porter price: $e");
        return '0';
      }
    }
    return '0';
  }

  @override
  Widget build(BuildContext context) {
    final hasDeparturePorter =
        selectedPorterServices.containsKey('departure') && selectedPorterServices['departure'] != null;
    final hasArrivalPorter = selectedPorterServices.containsKey('arrival') && selectedPorterServices['arrival'] != null;
    final hasTransitPorter = selectedPorterServices.containsKey('transit') && selectedPorterServices['transit'] != null;

    return Scaffold(
        backgroundColor: GrayColors.gray50,
        appBar: ProgressAppbarComponent(
          title: 'Pesan Tiket',
          subTitle: 'Langkah 4 dari 4',
          onTab: () {
            Get.back();
          },
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CardFlightInformation(
                    date: "$ticketDate",
                    time: "$departureTime - $arrivalTime",
                    departureCity: "${flightData?.cityDeparture}",
                    arrivalCity: "${flightData?.cityArrival}",
                    plane: "${flightData?.airLines} (${flightData?.code})",
                    seatClass: "${flightData?.flightClass}",
                    passenger: "$passenger",
                    transiAirplane: "${flightData?.transitAirplane}",
                    departurePorter: hasDeparturePorter ? "Keberangkatan (${getPorterInfo('departure')})" : null,
                    arrivalPorter: hasArrivalPorter ? "Kedatangan (${getPorterInfo('arrival')})" : null,
                    transitPorter: hasTransitPorter ? "Transit (${getPorterInfo('transit')})" : null,
                    stop: "${flightData?.stop}",
                  ),
                ),
                SizedBox(height: 32.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TypographyStyles.h6("Rincian Pesanan", color: GrayColors.gray800),
                ),
                SizedBox(height: 20.h),
                CustomeShadowCotainner(
                    sizeRadius: 0.r,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            TypographyStyles.body(
                              "${flightData?.airLines} (${flightData?.code})",
                              color: GrayColors.gray800,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(width: 10.w),
                            SvgPicture.asset('assets/images/citilink.svg', width: 40.w, height: 10.h),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        _buildRowPorterWithClass(
                          detailDeparturePorter: hasDeparturePorter ? "${getPorterInfo('departure')}" : null,
                          detailArrivalPorter: hasArrivalPorter ? "${getPorterInfo('arrival')}" : null,
                          detailTransitPorter: hasTransitPorter ? "${getPorterInfo('transit')}" : null,
                          detailSeatClass: "${flightData?.flightClass}",
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            TypographyStyles.caption(
                              "Rp ${NumberFormat.decimalPattern('id_ID').format(flightData?.price ?? 0.0)}",
                              color: GrayColors.gray600,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(width: 8.w),
                            TypographyStyles.small("x ${passenger}",
                                color: GrayColors.gray600, fontWeight: FontWeight.w400)
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Divider(thickness: 1.w, color: GrayColors.gray300),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TypographyStyles.caption(
                              "Total Pesanan",
                              color: GrayColors.gray600,
                              fontWeight: FontWeight.w400,
                            ),
                            TypographyStyles.body(
                              "Rp ${NumberFormat.decimalPattern('id_ID').format(totalPrice ?? 0.0)}",
                              color: GrayColors.gray600,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        _buildTextService(),
                        SizedBox(height: 2.h),
                        _buildRowText(context, text: "Biaya layanan", valueText: "10.000"),
                      ],
                    ))
              ],
            ),
          ),
        )),
        bottomNavigationBar: FooterPrice(
          labelText: "Pembayaran",
          price: "Rp ${NumberFormat.decimalPattern('id_ID').format(grandTotal)}",
          labelButton: "Buat Pesanan",
          iconButton: CustomeIcons.ProtectOutline(color: Colors.white),
          onTap: () {
            Get.toNamed(Routes.PAYMENT);
          },
        ));
  }

  Widget _buildRowPorterWithClass({
    required String? detailDeparturePorter,
    required String? detailArrivalPorter,
    required String? detailTransitPorter,
    required String detailSeatClass,
  }) {
    return Row(
      children: [
        if (detailDeparturePorter != null && detailDeparturePorter.isNotEmpty) ...[
          TypographyStyles.small(
            detailDeparturePorter,
            color: GrayColors.gray600,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(width: 10.w),
          CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
          SizedBox(width: 10.w),
        ],
        if (detailArrivalPorter != null && detailArrivalPorter.isNotEmpty) ...[
          TypographyStyles.small(
            detailArrivalPorter,
            color: GrayColors.gray600,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(width: 10.w),
          CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
          SizedBox(width: 10.h),
        ],
        if (detailTransitPorter != null && detailTransitPorter.isNotEmpty) ...[
          TypographyStyles.small(
            detailTransitPorter,
            color: GrayColors.gray600,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(width: 10.w),
          CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
          SizedBox(width: 10.h),
        ],
        TypographyStyles.small(detailSeatClass, color: GrayColors.gray600, fontWeight: FontWeight.w400),
      ],
    );
  }

  Widget _buildTextService() {
    final hasDeparturePorter =
        selectedPorterServices.containsKey('departure') && selectedPorterServices['departure'] != null;
    final hasArrivalPorter = selectedPorterServices.containsKey('arrival') && selectedPorterServices['arrival'] != null;
    final hasTransitPorter = selectedPorterServices.containsKey('transit') && selectedPorterServices['transit'] != null;
    final hasAnyPorter = hasDeparturePorter || hasArrivalPorter || hasTransitPorter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hasAnyPorter)
          _buildContainerText(left: 0.w, label: 'Layanan Porter', price: '-')
        else
          _buildContainerText(left: 0.w, label: 'Layanan Porter', price: ''),
        if (hasDeparturePorter)
          _buildContainerText(
            left: 8.w,
            label: "Keberangkatan (${getPorterInfo('departure')})",
            price: "Rp ${getPorterPrice('departure')}",
          ),
        if (hasArrivalPorter)
          _buildContainerText(
            left: 8.w,
            label: "Kedatangan (${getPorterInfo('arrival')})",
            price: "Rp ${getPorterPrice('arrival')}",
          ),
        if (hasTransitPorter)
          _buildContainerText(
            left: 8.w,
            label: "Transit (${getPorterInfo('transit')})",
            price: "Rp ${getPorterPrice('transit')}",
          ),
      ],
    );
  }

  Widget _buildRowText(
    BuildContext context, {
    required String text,
    required String valueText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TypographyStyles.caption(
          text,
          color: GrayColors.gray600,
          fontWeight: FontWeight.w400,
        ),
        TypographyStyles.caption(
          "Rp ${valueText}",
          color: GrayColors.gray600,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget _buildContainerText({
    required String label,
    required String price,
    required double left,
  }) {
    return Container(
      padding: EdgeInsets.only(left: left),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TypographyStyles.caption(label, color: GrayColors.gray600, fontWeight: FontWeight.w400),
          TypographyStyles.caption(price, color: GrayColors.gray600, fontWeight: FontWeight.w400),
        ],
      ),
    );
  }
}
