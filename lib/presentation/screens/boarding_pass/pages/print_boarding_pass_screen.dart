import 'dart:developer';
import 'dart:ui' as ui;
import 'package:e_porter/_core/utils/snackbar/snackbar_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/dotted/dashed_line_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/_core/utils/formatter/date_helper.dart';
import 'package:e_porter/presentation/controllers/history_controller.dart';
import 'package:e_porter/presentation/screens/home/component/card_tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

import '../../../../_core/component/appbar/appbar_component.dart';

class PrintBoardingPassScreen extends StatefulWidget {
  const PrintBoardingPassScreen({super.key});

  @override
  State<PrintBoardingPassScreen> createState() => _PrintBoardingPassScreenState();
}

class _PrintBoardingPassScreenState extends State<PrintBoardingPassScreen> {
  final GlobalKey _printKey = GlobalKey();
  final historyController = Get.find<HistoryController>();

  late final String transactionTicketId;
  late final String ticketId;
  late final int passenger;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    transactionTicketId = args['transactionId'];
    ticketId = args['ticketId'];
    passenger = args['passengerIndex'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTransactionData();
    });
  }

  Future<void> _loadTransactionData() async {
    try {
      await historyController.getTransactionFromFirestore(ticketId, transactionTicketId);
    } catch (e) {
      log('[Print Boarding Pass] Error getTransaction $e');
    }
  }

  Future<void> _printPass() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final pw.Document doc = pw.Document();
    final pageFormat = PdfPageFormat.a6.copyWith(
      marginLeft: 0,
      marginTop: 0,
      marginRight: 0,
      marginBottom: 0,
    );

    try {
      final ctx = _printKey.currentContext;
      if (ctx == null) throw 'Boarding pass belum siap';

      final boundary = ctx.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final pw.MemoryImage pwImage = pw.MemoryImage(pngBytes);
      doc.addPage(
        pw.Page(
          pageFormat: pageFormat,
          build: (c) => pw.Center(child: pw.Image(pwImage)),
        ),
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      SnackbarHelper.showError('Error', e.toString());
      return;
    }

    if (Get.isDialogOpen ?? false) Get.back();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      format: pageFormat,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Cetak Boarding Pass',
        textColor: Colors.white,
        backgroundColors: PrimaryColors.primary800,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: RepaintBoundary(
          key: _printKey,
          child: Obx(
            () {
              if (historyController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (historyController.errorMessage.value.isNotEmpty) {
                return Center(
                  child: TypographyStyles.body(
                    historyController.errorMessage.value,
                    color: GrayColors.gray400,
                  ),
                );
              }

              final transaction = historyController.selectedTransaction.value;
              if (transaction == null) {
                return Center(
                  child: TypographyStyles.body(
                    'Data transaksi tidak ditemukan',
                    color: GrayColors.gray400,
                  ),
                );
              }

              final departureTime = DateFormatterHelper.formatFlightTime(transaction.flightDetails['departureTime']);
              final arrivalTime = DateFormatterHelper.formatFlightTime(transaction.flightDetails['arrivalTime']);
              final ticketDate = DateFormatterHelper.formatFlightDate(transaction.flightDetails['departureTime']);
              final duration = DateFormatterHelper.calculateFlightDuration(
                transaction.flightDetails['departureTime'],
                transaction.flightDetails['arrivalTime'],
              );

              final seatNumber = transaction.numberSeat.length > passenger ? transaction.numberSeat[passenger] : '-';
              final passengerMap = (transaction.passengerDetails as List<dynamic>)[passenger] as Map<String, dynamic>;
              final idBarcode = passengerMap['idBarcode'] ?? '';

              final Map<String, dynamic>? svcMap = transaction.porterServiceDetails;
              final services = <String>[];
              if (svcMap?['departure'] != null) {
                services.add(svcMap!['departure']['name'] as String);
              }
              if (svcMap?['transit'] != null) {
                services.add(svcMap!['transit']['name'] as String);
              }
              if (svcMap?['arrival'] != null) {
                services.add(svcMap!['arrival']['name'] as String);
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomeShadowCotainner(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TypographyStyles.caption(
                                  'Kode Booking Maskapai',
                                  color: GrayColors.gray500,
                                  fontWeight: FontWeight.w400,
                                ),
                                TypographyStyles.h6(transaction.idBooking, color: GrayColors.gray800),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(thickness: 1, color: GrayColors.gray200),
                            ),
                            CardTickets(
                              withContainer: false,
                              showFooter: false,
                              airlineLogo: transaction.flightDetails['airlineLogo'],
                              departureCity: transaction.flightDetails['cityDeparture'],
                              arrivalCity: transaction.flightDetails['cityArrival'],
                              date: ticketDate,
                              departureCode: transaction.flightDetails['codeDeparture'],
                              arrivalCode: transaction.flightDetails['codeArrival'],
                              departureTime: departureTime,
                              arrivalTime: arrivalTime,
                              duration: duration,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(thickness: 1, color: GrayColors.gray200),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: layananClassGateSeat(
                                context: context,
                                services: services,
                                flightClass: transaction.flightDetails['flightClass'],
                                gate: transaction.flightDetails['gate'],
                                seatNumber: seatNumber,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: CustomDashedLine(),
                            ),
                            _buildBarcode(context, barcodeData: idBarcode)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.print_outlined, color: Colors.white, size: 24),
        label: TypographyStyles.caption('Cetak', color: Colors.white),
        onPressed: _printPass,
        backgroundColor: PrimaryColors.primary800,
      ),
    );
  }

  Widget layananClassGateSeat({
    required BuildContext context,
    required List<String> services,
    required String flightClass,
    required String gate,
    required String seatNumber,
  }) {
    if (services.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildColumnText(context, label: 'Layanan', value: '-'),
          _buildColumnText(context, label: 'Class', value: flightClass),
          _buildColumnText(context, label: 'Gate', value: gate),
          _buildColumnText(context, label: 'Seat', value: seatNumber),
        ],
      );
    }
    if (services.length == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildColumnText(context, label: 'Layanan', value: services.first),
          _buildColumnText(context, label: 'Class', value: flightClass),
          _buildColumnText(context, label: 'Gate', value: gate),
          _buildColumnText(context, label: 'Seat', value: seatNumber),
        ],
      );
    }
    final allServices = services.join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildColumnText(context, label: 'Layanan', value: allServices),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildColumnText(context, label: 'Class', value: flightClass),
            _buildColumnText(context, label: 'Gate', value: gate),
            _buildColumnText(context, label: 'Seat', value: seatNumber),
          ],
        ),
      ],
    );
  }

  Widget _buildColumnText(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TypographyStyles.small(label, color: GrayColors.gray500, fontWeight: FontWeight.w400),
        TypographyStyles.caption(
          value,
          color: GrayColors.gray800,
          maxlines: 1,
        )
      ],
    );
  }

  Widget _buildBarcode(BuildContext context, {required String barcodeData}) {
    return Column(
      children: [
        BarcodeWidget(
          barcode: Barcode.code128(),
          data: barcodeData,
          height: 80.h,
          drawText: false,
        ),
        SizedBox(height: 10.h),
        TypographyStyles.small(barcodeData, color: GrayColors.gray800, fontWeight: FontWeight.w400)
      ],
    );
  }
}
