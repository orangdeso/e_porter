import 'package:e_porter/presentation/controllers/history_controller.dart';
import 'package:e_porter/presentation/screens/boarding_pass/pages/print_boarding_pass_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanBarcodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan Boarding Pass')),
      body: MobileScanner(
        // Versi baru onDetect hanya terima satu arg
        onDetect: (capture) {
          for (final bar in capture.barcodes) {
            final raw = bar.rawValue;
            if (raw != null && raw.startsWith('P-')) {
              // hentikan scanner
              MobileScannerController().stop();
              // ambil tx dari HistoryController
              final history = Get.find<HistoryController>();
              final tx = history.selectedTransaction.value;
              if (tx != null) {
                final idx = (tx.passengerDetails as List).indexWhere((p) => p['idBarcode'] == raw);
                if (idx >= 0) {
                  // navigasi ke print screen
                  Get.to(
                    () => PrintBoardingPassScreen(),
                    arguments: {
                      'transactionId': tx.id,
                      'ticketId': tx.ticketId,
                      'passengerIndex': idx,
                    },
                  );
                  return;
                }
              }
              Get.snackbar('Error', 'Penumpang tidak ditemukan');
            }
          }
        },
      ),
    );
  }
}
