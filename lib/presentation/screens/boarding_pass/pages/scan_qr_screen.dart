import 'dart:developer';

import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';
import '../../../../_core/utils/snackbar/snackbar_helper.dart';
import '../../../../presentation/controllers/porter_queue_controller.dart';
import '../../../../presentation/controllers/transaction_controller.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({Key? key}) : super(key: key);

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final MobileScannerController cameraController = MobileScannerController(
    formats: [BarcodeFormat.qrCode, BarcodeFormat.aztec, BarcodeFormat.dataMatrix],
    detectionSpeed: DetectionSpeed.unrestricted,
    detectionTimeoutMs: 1000,
    facing: CameraFacing.back,
    torchEnabled: false,
    returnImage: true,
  );
  bool isProcessing = false;
  bool _isTorchOn = false;

  String ticketId = '';
  String transactionId = '';

  final PorterQueueController _porterQueueController = Get.find<PorterQueueController>();
  final TransactionController _transactionController = Get.find<TransactionController>();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    ticketId = args['ticketId'] ?? '';
    transactionId = args['transactionId'] ?? '';

    log('Transaction ID: $transactionId');
    log('Current Transaction: ${_transactionController.currentTransaction.value}');
    log('User Details: ${_transactionController.currentTransaction.value?.userDetails}');
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _resetScanner() {
    if (mounted) {
      setState(() => isProcessing = false);
      cameraController.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code Porter'),
        backgroundColor: PrimaryColors.primary800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: _isTorchOn ? Colors.yellow : Colors.white,
            ),
            onPressed: () {
              cameraController.toggleTorch();
              setState(() {
                _isTorchOn = !_isTorchOn;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            // controller: cameraController,
            scanWindow: Rect.fromCenter(
              center: Offset(
                MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height / 2,
              ),
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
            ),
            onDetect: (capture) {
              final raw = capture.barcodes.isNotEmpty ? capture.barcodes[0].rawValue : null;
              if (raw != null && !isProcessing) {
                _processQRCode(raw);
              }
            },
          ),
          ClipPath(
            clipper: OverlayClipper(),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              child: CustomPaint(
                painter: CornerPainter(
                  cornerColor: Colors.green,
                  cornerSize: 20,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  TypographyStyles.body(
                    'Scan QR code di lokasi porter',
                    color: GrayColors.gray800,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  TypographyStyles.caption(
                    'Posisikan kamera ke QR code yang tersedia di lokasi porter',
                    color: GrayColors.gray600,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          if (isProcessing)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16.h),
                    TypographyStyles.body(
                      'Sedang mencari porter…',
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _processQRCode(String rawLocation) async {
    log('[ScanQRScreen] Starting QR process (loc: $rawLocation)');

    setState(() => isProcessing = true);
    await cameraController.stop();

    try {
      // 1. Load transaksi jika perlu
      if (_transactionController.currentTransaction.value == null) {
        await _transactionController.getTransactionById(
          ticketId: ticketId,
          transactionId: transactionId,
        );
      }

      // 2. Ambil passengerId
      final userDetails = _transactionController.currentTransaction.value?.userDetails;
      final passengerId = userDetails?['uid'] as String?;
      if (passengerId == null || passengerId.isEmpty) {
        SnackbarHelper.showError(
          'Error',
          'User tidak dikenali, silakan login ulang atau coba lagi.',
        );
        // Reset scanner agar bisa scan lagi
        setState(() => isProcessing = false);
        await cameraController.start();
        return;
      }

      // 3. Request porter
      final result = await _porterQueueController.requestPorter(
        passengerId: passengerId,
        ticketId: ticketId,
        transactionId: transactionId,
        location: rawLocation,
      );
      await Future.delayed(Duration(seconds: 3));

      log('[ScanQRScreen] requestPorter succeeded: $result');

      SnackbarHelper.showSuccess(
        'Porter Ditemukan!',
        'Anda berhasil mendapatkan porter',
      );

      // 4. Sukses: navigasi ke Processing
      Get.toNamed(
        Routes.PROCESSING,
        arguments: {
          'location': rawLocation,
          'ticketId': ticketId,
          'transactionId': transactionId,
          'porterId': result['porterId']!,
          'porterTransactionId': result['transactionId']!,
        },
      );
    } on Exception catch (e) {
      final msg = e.toString();
      if (msg.contains('Porter tidak tersedia')) {
        // Porter sibuk → langsung pop dengan result
        Get.back(result: 'PORTER_BUSY');
        return;
      }

      // Error umum lain
      log('[ScanQRScreen] _processQRCode error: $e');
      SnackbarHelper.showError('Error', 'Terjadi kesalahan: $e');

      // Reset scanner agar bisa coba lagi
      setState(() => isProcessing = false);
      await cameraController.start();
    }
  }
}

class OverlayClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final scanAreaSize = size.width * 0.7;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(10)))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CornerPainter extends CustomPainter {
  final Color cornerColor;
  final double cornerSize;

  CornerPainter({
    required this.cornerColor,
    required this.cornerSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cornerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // Top left
    canvas.drawPath(
      Path()
        ..moveTo(0, cornerSize)
        ..lineTo(0, 0)
        ..lineTo(cornerSize, 0),
      paint,
    );

    // Top right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerSize, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, cornerSize),
      paint,
    );

    // Bottom right
    canvas.drawPath(
      Path()
        ..moveTo(size.width, size.height - cornerSize)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width - cornerSize, size.height),
      paint,
    );

    // Bottom left
    canvas.drawPath(
      Path()
        ..moveTo(cornerSize, size.height)
        ..lineTo(0, size.height)
        ..lineTo(0, size.height - cornerSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
