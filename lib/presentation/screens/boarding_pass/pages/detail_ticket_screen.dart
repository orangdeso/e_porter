import 'dart:developer';

import 'package:e_porter/_core/component/button/button_outline.dart';
import 'package:e_porter/_core/component/dotted/dashed_line_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/_core/utils/formatter/date_helper.dart';
import 'package:e_porter/presentation/controllers/history_controller.dart';
import 'package:e_porter/presentation/screens/boarding_pass/component/card_details_passenger.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/appbar/appbar_component.dart';
import '../../../../_core/component/button/button_fill.dart';
import '../../../../_core/component/card/custome_shadow_cotainner.dart';
import '../../../../_core/utils/snackbar/snackbar_helper.dart';
import '../../../../domain/models/transaction_model.dart';
import '../../home/component/title_show_modal.dart';

class DetailTicketScreen extends StatefulWidget {
  const DetailTicketScreen({super.key});

  @override
  State<DetailTicketScreen> createState() => _DetailTicketScreenState();
}

class _DetailTicketScreenState extends State<DetailTicketScreen> {
  late final String id_transaction;
  late final String id_ticket;

  final historyController = Get.find<HistoryController>();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    id_transaction = args['id_transaction'];
    id_ticket = args['id_ticket'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTransactionData();
    });
  }

  Future<void> _loadTransactionData() async {
    try {
      await historyController.getTransactionFromFirestore(id_ticket, id_transaction);
    } catch (e) {
      log('Error getTransaction $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Detail Tiket',
        textColor: Colors.white,
        backgroundColors: PrimaryColors.primary800,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Obx(
          () {
            if (historyController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (historyController.errorMessage.value.isNotEmpty) {
              return Center(
                child: TypographyStyles.body(historyController.errorMessage.value, color: GrayColors.gray400),
              );
            }

            final transaction = historyController.selectedTransaction.value;
            if (transaction == null) {
              return Center(child: TypographyStyles.body('Data transaksi tidak ditemukan', color: GrayColors.gray400));
            }

            final departureTime = DateFormatterHelper.formatFlightTime(transaction.flightDetails['departureTime']);
            final arrivalTime = DateFormatterHelper.formatFlightTime(transaction.flightDetails['arrivalTime']);
            final departureDate = DateFormatterHelper.formatFlightDate(transaction.flightDetails['departureTime']);
            final arrivalDate = DateFormatterHelper.formatFlightDate(transaction.flightDetails['arrivalTime']);
            final duration = DateFormatterHelper.calculateFlightDuration(
              transaction.flightDetails['departureTime'],
              transaction.flightDetails['arrivalTime'],
            );

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TypographyStyles.caption(
                      "Kode Booking Maskapai",
                      color: GrayColors.gray500,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 6.h),
                    TypographyStyles.body("${transaction.idBooking}", color: GrayColors.gray800),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: CustomDashedLine(),
                    ),
                    Row(
                      children: [
                        TypographyStyles.body(
                          "${transaction.flightDetails['airLines'] ?? 'Airline'} (${transaction.flightDetails['code'] ?? ''})",
                          color: GrayColors.gray800,
                        ),
                        SizedBox(width: 10.w),
                        Image.network(transaction.flightDetails['airlineLogo'], width: 40.w),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        TypographyStyles.small("Fast Track (FT)",
                            color: GrayColors.gray600, fontWeight: FontWeight.w400),
                        SizedBox(width: 10.w),
                        CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
                        SizedBox(width: 10.w),
                        TypographyStyles.small("${transaction.flightDetails['flightClass']}",
                            color: GrayColors.gray600, fontWeight: FontWeight.w400),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TypographyStyles.caption(departureTime, color: GrayColors.gray800),
                            TypographyStyles.small(departureDate,
                                color: GrayColors.gray600, fontWeight: FontWeight.w400),
                            SizedBox(height: 20.h),
                            TypographyStyles.small(duration, color: GrayColors.gray600, fontWeight: FontWeight.w400),
                            SizedBox(height: 20.h),
                            TypographyStyles.caption(arrivalTime, color: GrayColors.gray800),
                            TypographyStyles.small(arrivalDate, color: GrayColors.gray600, fontWeight: FontWeight.w400),
                          ],
                        ),
                        SizedBox(width: 20.w),
                        SvgPicture.asset('assets/images/garis.svg', height: 100.h),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TypographyStyles.caption(
                                "${transaction.flightDetails['cityDeparture']} (${transaction.flightDetails['codeDeparture']})",
                                color: GrayColors.gray800,
                              ),
                              TypographyStyles.caption(
                                "${transaction.bandaraDetails['departure']?['name']}",
                                color: GrayColors.gray600,
                                fontWeight: FontWeight.w400,
                                maxlines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 58.h),
                              TypographyStyles.caption(
                                "${transaction.flightDetails['cityArrival']} (${transaction.flightDetails['codeArrival']})",
                                color: GrayColors.gray800,
                              ),
                              TypographyStyles.caption(
                                "${transaction.bandaraDetails['arrival']?['name']}",
                                color: GrayColors.gray600,
                                fontWeight: FontWeight.w400,
                                maxlines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: CustomDashedLine(),
                    ),
                    TypographyStyles.h6("Detail Penumpang", color: GrayColors.gray800),
                    SizedBox(height: 20.h),
                    ListView.builder(
                      itemCount: transaction.passengerDetails.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final passenger = transaction.passengerDetails[index];
                        final seatNumber =
                            index < transaction.numberSeat.length ? transaction.numberSeat[index] : 'N/A';

                        String maskedId = 'N/A';
                        if (passenger['noId'] != null) {
                          String idNumber = passenger['noId'].toString();
                          if (idNumber.length > 4) {
                            maskedId = '${idNumber.substring(0, 4)}${'•' * (idNumber.length - 4)}';
                          } else {
                            maskedId = idNumber;
                          }
                        }

                        return CardDetailsPassenger(
                          name: passenger['name'] ?? 'N/A',
                          typeId: passenger['typeId'] ?? 'N/A',
                          noId: maskedId,
                          seatClass: '${transaction.flightDetails['flightClass']}',
                          numberSeat: seatNumber,
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (historyController.isLoading.value) {
          return SizedBox.shrink();
        }

        final transaction = historyController.selectedTransaction.value;
        if (transaction == null) {
          return SizedBox.shrink();
        }

        if (transaction.status == 'pending') {
          return CustomeShadowCotainner(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: ButtonFill(
              text: 'Upload Bukti Pembayaran',
              textColor: Colors.white,
              onTap: () {
                Get.toNamed(
                  Routes.UPLOADFILE,
                  arguments: {'ticketId': transaction.ticketId, 'transactionId': transaction.id, 'mode': 'history'},
                );
              },
            ),
          );
        } else if (transaction.status == 'active') {
          if (transaction.porterServiceDetails == null ||
              (transaction.porterServiceDetails as Map<String, dynamic>).isEmpty) {
            return CustomeShadowCotainner(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: ButtonFill(
                text: 'Cetak Boarding Pass',
                textColor: Colors.white,
                onTap: () => _showCetakBoardingPassBottomSheet(transaction),
              ),
            );
          } else {
            return CustomeShadowCotainner(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ButtonOutline(
                    text: 'Scan QR Code Porter',
                    textColor: PrimaryColors.primary800,
                    onTap: () async {
                      await Permission.camera.status;

                      final result = await Get.toNamed(
                        Routes.SCANQR,
                        arguments: {
                          'ticketId': transaction.ticketId,
                          'transactionId': transaction.id,
                        },
                      );

                      if (result == 'PORTER_BUSY') {
                        SnackbarHelper.showError(
                          'Porter Tidak Tersedia',
                          'Tidak ada porter yang tersedia atau semua porter sedang sibuk, coba nanti.',
                        );
                        return;
                      }
                    },
                  ),
                  SizedBox(height: 12.h),
                  ButtonFill(
                    text: 'Cetak Boarding Pass',
                    textColor: Colors.white,
                    onTap: () => _showCetakBoardingPassBottomSheet(transaction),
                  ),
                ],
              ),
            );
          }
        } else {
          return CustomeShadowCotainner(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: ButtonFill(
              text: 'Cetak Boarding Pass',
              textColor: Colors.white,
              onTap: () => _showCetakBoardingPassBottomSheet(transaction),
            ),
          );
        }
      }),
    );
  }

  void _showCetakBoardingPassBottomSheet(TransactionModel transaction) {
    Get.bottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        child: Wrap(
          children: [
            TitleShowModal(text: 'Cetak Boarding Pass'),
            SizedBox(height: 30.h),
            ListView.builder(
              itemCount: transaction.passengerDetails.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final passenger = transaction.passengerDetails[index];

                String maskedId = 'N/A';
                if (passenger['noId'] != null) {
                  String idNumber = passenger['noId'].toString();
                  if (idNumber.length > 4) {
                    maskedId = '${idNumber.substring(0, 4)}${'•' * (idNumber.length - 4)}';
                  } else {
                    maskedId = idNumber;
                  }
                }

                return Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: _buildCetakBoardingPass(
                    context,
                    name: passenger['name'] ?? 'N/A',
                    typeId: passenger['typeId'] ?? '',
                    noId: maskedId,
                    onTap: () {
                      Get.toNamed(Routes.PRINTBOARDINGPASS, arguments: {
                        'transactionId': transaction.id,
                        'ticketId': transaction.ticketId,
                        'passengerIndex': index,
                      });
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCetakBoardingPass(
    BuildContext context, {
    required String name,
    required String typeId,
    required String noId,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: GrayColors.gray50,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(width: 1.w, color: GrayColors.gray200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypographyStyles.body(name, color: GrayColors.gray800),
              SizedBox(height: 4.h),
              TypographyStyles.caption("${typeId} - ${noId}", color: GrayColors.gray500, fontWeight: FontWeight.w400),
            ],
          ),
          ZoomTapAnimation(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: PrimaryColors.primary800,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TypographyStyles.small('Cetak Sekarang', color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
