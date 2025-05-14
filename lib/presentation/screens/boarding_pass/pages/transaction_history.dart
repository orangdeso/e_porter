import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/_core/utils/formatter/date_helper.dart';
import 'package:e_porter/presentation/controllers/history_controller.dart';
import 'package:e_porter/presentation/screens/boarding_pass/component/card_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../_core/component/appbar/appbar_component.dart';

class transactionHistory extends StatefulWidget {
  const transactionHistory({super.key});

  @override
  State<transactionHistory> createState() => _transactionHistoryState();
}

class _transactionHistoryState extends State<transactionHistory> {
  final _historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Riwayat Transaksi',
        textColor: Colors.white,
        backgroundColors: PrimaryColors.primary800,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Obx(
            () {
              final list = _historyController.historyTransactions;
              if (list.isEmpty) {
                return Center(
                  child: TypographyStyles.caption(
                    'Tidak ada riwayat transaksi',
                    color: GrayColors.gray400,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => _historyController.refreshTransactions(_historyController.getUserId()),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final transaction = list[index];

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

                    final departureDate =
                        DateFormatterHelper.formatFlightDate(transaction.flightDetails['departureTime']);
                    final duration = DateFormatterHelper.calculateFlightDuration(
                        transaction.flightDetails['departureTime'], transaction.flightDetails['arrivalTime']);
                    final price = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                        .format(transaction.amount);

                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: CardTransaction(
                        bookingCode: transaction.idBooking,
                        airlineLogo: transaction.flightDetails['airlineLogo'],
                        departureCode: transaction.flightDetails['codeDeparture'],
                        arrivalCode: transaction.flightDetails['codeArrival'],
                        ticketDate: departureDate,
                        flightClass: transaction.flightDetails['flightClass'],
                        servicePorter: services.join(", "),
                        duration: duration,
                        price: price,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
