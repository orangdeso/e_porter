import 'dart:developer';

import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/controllers/transaction_porter_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../_core/component/appbar/appbar_component.dart';
import '../../../../_core/constants/colors.dart';

class ProcessingPorterScreen extends StatefulWidget {
  const ProcessingPorterScreen({Key? key}) : super(key: key);

  @override
  State<ProcessingPorterScreen> createState() => _ProcessingPorterScreenState();
}

class _ProcessingPorterScreenState extends State<ProcessingPorterScreen> {
  final TransactionPorterController _porterController = Get.find<TransactionPorterController>();

  late final String location;
  late final String ticketId;
  late final String transactionId;
  late final String porterOnlineId;
  late final String transactionPorterId;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat _timeFormat = DateFormat('HH:mm');

  @override
  void initState() {
    super.initState();
    // final args = Get.arguments as Map<String, dynamic>;
    // final location = args['location'] ?? '';
    // final ticketId = args['ticketId'] ?? '';
    // final transactionId = args['transactionId'];
    // final porterOnlineId = args['porterOnlineId'];
    // final transactionPorterId = args['transactionPorterId'] ?? '';
    _initializeData();
  }

  void _initializeData() {
    final args = Get.arguments as Map<String, dynamic>;
    location = args['location'] ?? '';
    ticketId = args['ticketId'] ?? '';
    transactionId = args['transactionId'] ?? '';
    porterOnlineId = args['porterOnlineId'] ?? '';
    transactionPorterId = args['transactionPorterId'] ?? '';

    if (transactionPorterId.isEmpty) {
      log('Error: transactionPorterId tidak tersedia dalam arguments');
      Get.back();
      return;
    }

    log('Memulai pemantauan transaksi porter: $transactionPorterId');

    // Dapatkan detail transaksi dan mulai memantau perubahan
    _porterController.getTransactionById(transactionPorterId).then((transaction) {
      if (transaction == null) {
        log('Transaksi tidak ditemukan: $transactionPorterId');
      } else {
        log('Transaksi ditemukan: ${transaction.id}, status: ${transaction.status}');
      }
    }).catchError((e) {
      log('Error mendapatkan transaksi: $e');
    });

    // Mulai memantau transaksi secara real-time
    _porterController.watchTransaction(transactionPorterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Mencari Porter',
        textColor: Colors.white,
        backgroundColors: PrimaryColors.primary800,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(child: Obx(
        () {
          final transaction = _porterController.currentTransaction.value;
          final isLoading = _porterController.isLoading.value;
          final error = _porterController.error.value;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48.h, color: Colors.red),
                  SizedBox(height: 16.h),
                  TypographyStyles.body(
                    'Terjadi Kesalahan',
                    color: Colors.red,
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: TypographyStyles.caption(
                      error,
                      color: GrayColors.gray600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ButtonFill(
                    text: 'Kembali',
                    textColor: Colors.white,
                    onTap: () => Get.back(),
                  ),
                ],
              ),
            );
          }
          if (transaction == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 48.h, color: GrayColors.gray400),
                  SizedBox(height: 16.h),
                  TypographyStyles.body(
                    'Transaksi tidak ditemukan',
                    color: GrayColors.gray600,
                  ),
                  SizedBox(height: 16.h),
                  ButtonFill(
                    text: 'Kembali',
                    textColor: Colors.white,
                    onTap: () => Get.back(),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildPorterStatusCard(transaction.status),
                  SizedBox(height: 20.h),
                  _buildPorterDetailsCard(transaction),
                ],
              ),
            ),
          );
        },
      )),
      bottomNavigationBar: CustomeShadowCotainner(
        child: ButtonFill(
          text: 'Kembali ke menu',
          textColor: Colors.white,
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildDesignOld() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TypographyStyles.h1('Ilustrasi'),
            SizedBox(height: 32.h),
            CustomeShadowCotainner(
              child: Column(
                children: [
                  TypographyStyles.h6('Tunggu Portermu', color: GrayColors.gray800),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TypographyStyles.caption(
                        'Tunngu dari pihak Porter merespon',
                        color: GrayColors.gray500,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.timelapse_outlined)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            CustomeShadowCotainner(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypographyStyles.body('Ahmad Choirul Umam', color: GrayColors.gray800),
                  SizedBox(height: 10.h),
                  Divider(thickness: 1, color: GrayColors.gray200),
                  SizedBox(height: 10.h),
                  TypographyStyles.body('Lokasi', color: GrayColors.gray800),
                  SizedBox(height: 10.h),
                  // _buildRowLocation(location: 'Gate Penerbangan', desc: 'Lokasi Anda'),
                  SizedBox(height: 10.h),
                  // _buildRowLocation(location: 'Guyangan', desc: 'Lokasi Porter Anda'),
                  SizedBox(height: 10.h),
                  // _buildRowLocation(location: 'Porter menuju ke lokasi anda', desc: 'Porter bergerak'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPorterStatusCard(String status) {
    String statusText = '';
    Widget statusIcon = const SizedBox.shrink();

    switch (status.toLowerCase()) {
      case 'pending':
        statusText = 'Tunggu Portermu';
        statusIcon = Icon(Icons.timelapse_outlined, color: Colors.orange);
        break;
      case 'proses':
        statusText = 'Porter dalam Perjalanan';
        statusIcon = Icon(Icons.directions_walk, color: PrimaryColors.primary800);
        break;
      case 'selesai':
        statusText = 'Layanan Porter Selesai';
        statusIcon = Icon(Icons.check_circle, color: Colors.green);
        break;
      default:
        statusText = 'Status Porter Tidak Diketahui';
        statusIcon = Icon(Icons.help_outline, color: GrayColors.gray400);
    }

    return CustomeShadowCotainner(
      child: Column(
        children: [
          TypographyStyles.h6(statusText, color: GrayColors.gray800),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TypographyStyles.caption(
                _getStatusDescription(status),
                color: GrayColors.gray500,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(width: 4.w),
              statusIcon,
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusDescription(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Tunggu dari pihak Porter merespon';
      case 'proses':
        return 'Porter sedang menuju lokasi Anda';
      case 'selesai':
        return 'Layanan porter telah selesai';
      default:
        return 'Status tidak diketahui';
    }
  }

  Widget _buildPorterDetailsCard(dynamic transaction) {
    final now = DateTime.now();

    return CustomeShadowCotainner(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypographyStyles.body('Informasi Porter', color: GrayColors.gray800),
          SizedBox(height: 10.h),
          Divider(thickness: 1, color: GrayColors.gray200),
          SizedBox(height: 10.h),
          TypographyStyles.body('Lokasi', color: GrayColors.gray800),
          SizedBox(height: 10.h),
          _buildRowLocation(
            location: location.isNotEmpty ? location : transaction.locationPassenger,
            desc: 'Lokasi Anda',
            timestamp: transaction.createdAt,
          ),
          SizedBox(height: 10.h),
          _buildRowLocation(
            location: transaction.locationPorter,
            desc: 'Lokasi Porter Anda',
            timestamp: transaction.createdAt,
          ),
          SizedBox(height: 10.h),
          _buildRowLocation(
            location: _getLocationStatusText(transaction.status),
            desc: 'Status Porter',
            timestamp: now,
          ),
          SizedBox(height: 10.h),
          TypographyStyles.body('Kode Porter', color: GrayColors.gray800),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: PrimaryColors.primary100,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: TypographyStyles.h6(
              transaction.kodePorter,
              color: PrimaryColors.primary800,
            ),
          ),
        ],
      ),
    );
  }

  String _getLocationStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Menunggu konfirmasi porter';
      case 'proses':
        return 'Porter menuju ke lokasi anda';
      case 'selesai':
        return 'Layanan porter selesai';
      default:
        return 'Status tidak diketahui';
    }
  }

  Widget _buildRowLocation({
    required String location,
    required String desc,
    required DateTime timestamp,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TypographyStyles.caption(
              _dateFormat.format(timestamp),
              color: GrayColors.gray600,
              fontWeight: FontWeight.w400,
            ),
            TypographyStyles.caption(
              _timeFormat.format(timestamp),
              color: GrayColors.gray600,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypographyStyles.caption(
                location,
                color: GrayColors.gray800,
                fontWeight: FontWeight.w600,
              ),
              TypographyStyles.small(
                desc,
                color: GrayColors.gray600,
                fontWeight: FontWeight.w400,
              )
            ],
          ),
        ),
      ],
    );
  }
}
