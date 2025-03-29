// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/_core/service/logger_service.dart';
import 'package:e_porter/domain/models/ticket_model.dart';
import 'package:e_porter/presentation/controllers/ticket_controller.dart';
import 'package:e_porter/presentation/screens/home/component/card_indicator.dart';
import 'package:e_porter/presentation/screens/home/component/card_seat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/button/button_fill.dart';
import '../../../../domain/models/user_entity.dart';

class ChooseSeatScreen extends StatefulWidget {
  const ChooseSeatScreen({super.key});

  @override
  State<ChooseSeatScreen> createState() => _ChooseSeatScreenState();
}

class _ChooseSeatScreenState extends State<ChooseSeatScreen> {
  final List<bool> selectedSeats = List.generate(3, (_) => false);
  final Map<String, bool> selectedSeatsMap = {};
  late List<String> selectedSeatNumbers;
  int currentPassenger = 0;
  late final String ticketId;
  late final String flightId;
  late Future<FlightModel> _flightFuture;
  late final int passenger;
  late final List<PassengerModel?> selectedPassengers;
  late final TicketController ticketController;

  String? cityDeparture;
  String? cityArrival;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    ticketId = args['ticketId'];
    flightId = args['flightId'];
    passenger = args['passenger'] ?? '';
    selectedPassengers = args['selectedPassenger'] ?? [];

    ticketController = Get.find<TicketController>();
    _flightFuture = ticketController.getFlightById(ticketId: ticketId, flightId: flightId);

    _loadFlightData();

    selectedSeatNumbers = List.filled(passenger, '');
    if (passenger > 0) {
      currentPassenger = 0;
      for (int i = 0; i < selectedSeats.length; i++) {
        selectedSeats[i] = false;
      }
      selectedSeats[0] = true;
    }
  }

  void _loadFlightData() async {
    try {
      final flight = await ticketController.getFlightById(ticketId: ticketId, flightId: flightId);
      if (mounted) {
        setState(() {
          cityDeparture = flight.cityDeparture;
          cityArrival = flight.cityArrival;
          _flightFuture = Future.value(flight);
        });
      }
    } catch (e) {
      logger.e('Error loading flight data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: CustomeAppbarComponent(
        valueDari: 'Pilih Kursi',
        valueKe: null,
        date: '$cityDeparture - $cityArrival',
        passenger: '$passenger',
        onTab: () {
          Get.back();
        },
      ),
      body: FutureBuilder<FlightModel>(
        future: _flightFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("Data tidak ditemukan"));
          }

          final flight = snapshot.data!;
          final codeDeparture = flight.codeDeparture;
          final codeArrival = flight.codeArrival;
          final codeTransit = flight.codeTransit;
          final flightClass = flight.flightClass;
          final airlineLogo = flight.airlineLogo;
          cityDeparture = flight.cityDeparture;
          cityArrival = flight.cityArrival;

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

          // Ambil data seat per kolom
          final seatInfoA = flight.seat['a'];
          final seatInfoB = flight.seat['b'];
          final seatInfoC = flight.seat['c'];
          final seatInfoD = flight.seat['d'];
          final seatInfoE = flight.seat['e'];
          final seatInfoF = flight.seat['f'];

          // Ambil totalSeat per kolom
          final rowCountA = seatInfoA?.totalSeat ?? 0;
          final rowCountB = seatInfoB?.totalSeat ?? 0;
          final rowCountC = seatInfoC?.totalSeat ?? 0;
          final rowCountD = seatInfoD?.totalSeat ?? 0;
          final rowCountE = seatInfoE?.totalSeat ?? 0;
          final rowCountF = seatInfoF?.totalSeat ?? 0;

          // Ambil isTaken per kolom
          final seatA = seatInfoA?.isTaken ?? [];
          final seatB = seatInfoB?.isTaken ?? [];
          final seatC = seatInfoC?.isTaken ?? [];
          final seatD = seatInfoD?.isTaken ?? [];
          final seatE = seatInfoE?.isTaken ?? [];
          final seatF = seatInfoF?.isTaken ?? [];

          // Jika ingin menentukan maxRows untuk nomor baris di tengah (misalnya)
          final int maxRows = [
            rowCountA,
            rowCountB,
            rowCountC,
            rowCountD,
            rowCountE,
            rowCountF,
          ].reduce((a, b) => a > b ? a : b);

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: GrayColors.gray50,
                  foregroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  expandedHeight: 220.h,
                  flexibleSpace: FlexibleSpaceBar(
                    background: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCardFlight(
                            departureCode: codeDeparture,
                            transitCode: codeTransit,
                            arrivalCode: codeArrival,
                            kelas: flightClass,
                            duration: finalDuration,
                            airlineLogo: airlineLogo,
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            height: 84.h,
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.w),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: selectedPassengers.length,
                                itemBuilder: (context, index) {
                                  final passengerData = selectedPassengers[index];
                                  return Padding(
                                    padding: EdgeInsets.only(right: 16.w),
                                    child: _buildPassengerCard(
                                      passengerData?.name ?? "Penumpang ${index + 1}",
                                      flightClass,
                                      '',
                                      index,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverHeaderDelegate(
                    minHeight: 50.h,
                    maxHeight: 50.h,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      alignment: Alignment.centerLeft,
                      child: _buildCardInformationStatus(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomeShadowCotainner(
                    sizeRadius: 0.r,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSeatColumn("A", seatA, rowCountA),
                        _buildSeatColumn("B", seatB, rowCountB),
                        _buildSeatColumn("C", seatC, rowCountC),
                        SizedBox(width: 16.w),
                        _buildRowNumbers(maxRows),
                        SizedBox(width: 16.w),
                        _buildSeatColumn("D", seatD, rowCountD),
                        _buildSeatColumn("E", seatE, rowCountE),
                        _buildSeatColumn("F", seatF, rowCountF),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: ZoomTapAnimation(
          child: ButtonFill(
            text: 'Lanjutkan',
            textColor: Colors.white,
            backgroundColor:
                selectedSeatNumbers.any((seat) => seat.isEmpty) ? GrayColors.gray400 : PrimaryColors.primary800,
            onTap: () {
              if (selectedSeatNumbers.any((seat) => seat.isEmpty)) {
                return;
              }
              log('Nomor Kursi: $selectedSeatNumbers');
              Get.back(result: selectedSeatNumbers);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardFlight({
    required String departureCode,
    required String transitCode,
    required String arrivalCode,
    required String kelas,
    required String duration,
    String? airlineLogo,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h),
      child: CustomeShadowCotainner(
        child: Row(
          children: [
            airlineLogo != null && airlineLogo.isNotEmpty
                ? Image.network(
                    airlineLogo,
                    width: 40.w,
                    height: 26.h,
                    errorBuilder: (context, error, stackTrace) {
                      print("Error loading image: $error");
                      return Container(
                        width: 40.w,
                        height: 10.h,
                        child: Center(child: Icon(Icons.error)),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 40.w,
                        height: 10.h,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 1.0)),
                      );
                    },
                  )
                : SvgPicture.asset('assets/images/citilink.svg', width: 40.w, height: 10.h),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TypographyStyles.body(departureCode, color: GrayColors.gray800),
                    SizedBox(width: 10.w),
                    CustomeIcons.RightOutline(color: GrayColors.gray800, size: 14),
                    SizedBox(width: 10.w),
                    if (transitCode != null && transitCode.isNotEmpty) ...[
                      TypographyStyles.body(transitCode, color: GrayColors.gray800),
                      SizedBox(width: 10.w),
                      CustomeIcons.RightOutline(color: GrayColors.gray800, size: 14),
                      SizedBox(width: 10.w),
                    ],
                    TypographyStyles.body(arrivalCode, color: GrayColors.gray800),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    TypographyStyles.small(kelas, color: GrayColors.gray600, fontWeight: FontWeight.w400),
                    SizedBox(width: 10.w),
                    CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
                    SizedBox(width: 10.w),
                    TypographyStyles.small(duration, color: GrayColors.gray600, fontWeight: FontWeight.w400),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerCard(String name, String kelas, String seat, int index) {
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: () {
          setState(() {
            for (int i = 0; i < selectedSeats.length; i++) {
              selectedSeats[i] = false;
            }
            selectedSeats[index] = true;
            currentPassenger = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selectedSeats[index] ? PrimaryColors.primary800 : GrayColors.gray200,
              width: 1.w,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypographyStyles.body(
                name,
                color: GrayColors.gray800,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 2.h),
              TypographyStyles.caption(
                '${kelas} / Kursi ${selectedSeatNumbers[index].isEmpty ? '-' : selectedSeatNumbers[index]}',
                color: GrayColors.gray600,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardInformationStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CardIndicator(
          text: 'Kosong',
          border: Border.all(width: 1.w, color: PrimaryColors.primary800),
        ),
        SizedBox(width: 32.w),
        CardIndicator(
          text: 'Terisi',
          boxColor: GrayColors.gray300,
        ),
        SizedBox(width: 32.w),
        CardIndicator(
          text: 'Dipilih',
          textColor: PrimaryColors.primary800,
          boxColor: PrimaryColors.primary900,
        )
      ],
    );
  }

  Widget _buildSeatColumn(String column, List<bool> seatList, int totalSeat) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            alignment: Alignment.center,
            child: TypographyStyles.body(
              column,
              color: GrayColors.gray800,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          ListView.builder(
            itemCount: totalSeat,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final seatKey = '$column${index + 1}';
              bool taken = false;
              if (index < seatList.length) {
                taken = seatList[index];
              }
              bool isSelected = selectedSeatsMap[seatKey] ?? false;
              return Padding(
                padding: EdgeInsets.only(top: 6.h, bottom: 6.h, right: 10.w),
                child: GestureDetector(
                  onTap: () {
                    if (!taken) {
                      setState(() {
                        final oldSeatKey = selectedSeatNumbers[currentPassenger];
                        if (oldSeatKey.isNotEmpty) {
                          selectedSeatsMap[oldSeatKey] = false;
                        }

                        selectedSeatsMap[seatKey] = true;
                        selectedSeatNumbers[currentPassenger] = seatKey;
                      });
                    }
                  },
                  child: CardSeat(
                    isTaken: taken,
                    isSelected: isSelected,
                    seatLabel: seatKey,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRowNumbers(int total) {
    return Expanded(
      child: Column(
        children: List.generate(
          total,
          (index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Container(
              width: 40.w,
              height: 40.h,
              alignment: Alignment.center,
              child: TypographyStyles.body(
                '${index + 1}',
                color: GrayColors.gray800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
