// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'dart:developer';

import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/domain/models/transaction_model.dart';
import 'package:e_porter/domain/models/transaction_porter_model.dart';
import 'package:e_porter/presentation/controllers/history_controller.dart';
import 'package:e_porter/presentation/controllers/transaction_porter_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailHistoryPorterScreen extends StatefulWidget {
  const DetailHistoryPorterScreen({super.key});

  @override
  State<DetailHistoryPorterScreen> createState() => _DetailHistoryPorterScreenState();
}

class _DetailHistoryPorterScreenState extends State<DetailHistoryPorterScreen> {
  final TransactionPorterController _porterController = Get.find<TransactionPorterController>();
  final HistoryController _historyController = Get.find<HistoryController>();
  final RxBool _isLoadingTicket = false.obs;

  PorterTransactionModel? porterTransaction;

  late final String porterTransactionId;

  // Formatters
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy', 'en_US');
  final DateFormat _timeFormat = DateFormat.jm();
  //  final NumberFormat _priceFormatter = NumberFormat.decimalPattern('id_ID');

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    porterTransactionId = args['transactionPorterId'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTransactioPorterById();
      _fetchTransactionData();
    });

    log('[Detail History Porter] ID Transaction Porter : $porterTransactionId');
  }

  Future<void> _fetchTransactioPorterById() async {
    try {
      await _porterController.getTransactionById(porterTransactionId);
      log('[Detail History Porter] Transaction fetched: ${_porterController.currentTransaction.value}');
    } catch (e) {
      log('[Detail History Porter] Error getTransaction $e');
    }
  }

  Future<void> _fetchTransactionData() async {
    try {
      await _porterController.getTransactionById(porterTransactionId);
      final porterTransaction = _porterController.currentTransaction.value;

      if (porterTransaction != null && porterTransaction.ticketId != null && porterTransaction.transactionId != null) {
        await _historyController.getTransactionFromFirestore(
            porterTransaction.ticketId, porterTransaction.transactionId);
      }
    } catch (e) {
      log('[Detail History Porter] Error fetching data: $e');
    } finally {
      _isLoadingTicket.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Detail Riwayat',
        textColor: Colors.white,
        backgroundColors: PrimaryColors.primary800,
        onTab: () {
          Get.back();
        },
      ),
      body: Obx(() {
        final porterTransaction = _porterController.currentTransaction.value;
        final ticketTransaction = _historyController.selectedTransaction.value;
        final isLoadingPorter = _porterController.isLoading.value;
        final isLoadingTicket = _isLoadingTicket.value;

        if (isLoadingPorter || isLoadingTicket) {
          return const Center(child: CircularProgressIndicator());
        } else if (porterTransaction == null) {
          return const Center(child: Text('Data transaksi tidak ditemukan'));
        }

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildStatusCard(porterTransaction),
                  SizedBox(height: 20.h),
                  _buildInfoPassenger(ticketTransaction),
                  SizedBox(height: 20.h),
                  _buildLocationPassenger(porterTransaction),
                  SizedBox(height: 20.h),
                  _buildDetailsOrder(ticketTransaction),
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final transaction = _porterController.currentTransaction.value;
        if (transaction == null || _porterController.isLoading.value) {
          return const SizedBox.shrink();
        }
        switch (transaction.normalizedStatus) {
          case 'pending':
            return CustomeShadowCotainner(
              child: ButtonFill(
                text: 'Terima Orderan',
                textColor: Colors.white,
                onTap: () {
                  _porterController.updateTransactionStatus(
                    transactionId: porterTransactionId,
                    status: 'proses',
                  );
                },
              ),
            );

          case 'proses':
            return CustomeShadowCotainner(
              child: ButtonFill(
                text: 'Selesaikan Orderan',
                textColor: Colors.white,
                onTap: () {
                  _porterController.completePorterTransaction(
                    transactionId: porterTransactionId,
                  );
                },
              ),
            );

          case 'selesai':
            return const SizedBox.shrink();

          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }

  Widget _buildStatusCard(PorterTransactionModel porterTransaction) {
    return CustomeShadowCotainner(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: _getStatusColor(porterTransaction).withOpacity(0.1),
            child: Icon(
              _getStatusIcon(porterTransaction),
              color: _getStatusColor(porterTransaction),
              size: 24.sp,
            ),
          ),
          SizedBox(width: 20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypographyStyles.caption(
                'Status Transaksi',
                color: GrayColors.gray500,
                fontWeight: FontWeight.w500,
              ),
              TypographyStyles.h5(
                porterTransaction.status,
                color: _getStatusColor(porterTransaction),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPassenger(TransactionModel? ticketTransaction) {
    return CustomeShadowCotainner(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _componentHeaderText(text: 'Informasi Penumpang', svgIcon: 'assets/icons/ic_account.svg'),
          if (ticketTransaction != null && ticketTransaction.passengerDetails.isNotEmpty)
            ..._buildPassengerDetailsList(ticketTransaction)
          else
            TypographyStyles.body(
              'Data penumpang tidak tersedia',
              color: GrayColors.gray500,
              fontWeight: FontWeight.w600,
            ),
        ],
      ),
    );
  }

  List<Widget> _buildPassengerDetailsList(TransactionModel ticketTransaction) {
    final List<Widget> passengerWidgets = [];

    for (int i = 0; i < ticketTransaction.passengerDetails.length; i++) {
      final passenger = ticketTransaction.passengerDetails[i];

      passengerWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TypographyStyles.body('Penumpang ${i + 1}', color: GrayColors.gray800, fontWeight: FontWeight.w600),
            SizedBox(height: 8.h),
            _componentRowText(label: 'Nama', value: passenger['name'] ?? 'N/A'),
            SizedBox(height: 6.h),
            _componentRowText(label: 'Jenis Kelamin', value: passenger['gender'] ?? 'N/A'),
            if (i < ticketTransaction.passengerDetails.length - 1) SizedBox(height: 16.h),
          ],
        ),
      );
    }

    return passengerWidgets;
  }

  Widget _buildLocationPassenger(PorterTransactionModel porterTransaction) {
    final orderDate = _dateFormat.format(porterTransaction.createdAt);
    final orderTime = _timeFormat.format(porterTransaction.createdAt);

    return CustomeShadowCotainner(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _componentHeaderText(text: 'Lokasi Layanan', svgIcon: 'assets/icons/ic_account.svg'),
          _componentRowText(label: 'Lokasi Penumpang', value: porterTransaction.locationPassenger),
          SizedBox(height: 6.h),
          _componentRowText(label: 'Lokasi Anda', value: porterTransaction.locationPorter),
          SizedBox(height: 6.h),
          _componentRowText(label: 'Tanggal Order', value: orderDate),
          SizedBox(height: 6.h),
          _componentRowText(label: 'Waktu Order', value: orderTime),
        ],
      ),
    );
  }

  Widget _buildDetailsOrder(TransactionModel? ticketTransaction) {
    return CustomeShadowCotainner(
      child: Column(
        children: [
          _componentHeaderText(text: 'Rincian Pesanan', svgIcon: 'assets/icons/ic_account.svg'),
          _componentRowText(
            label: 'Keberangkatan',
            value: '${ticketTransaction?.porterServiceDetails?['departure']?['name'] ?? '-'}',
          ),
          _componentRowText(
            label: 'Kedatangan',
            value: '${ticketTransaction?.porterServiceDetails?['arrival']?['name'] ?? '-'}',
          ),
          _componentRowText(
            label: 'Transit',
            value: '${ticketTransaction?.porterServiceDetails?['transit']?['name'] ?? '-'}',
          ),
        ],
      ),
    );
  }

  Widget _componentHeaderText({required String text, required String svgIcon}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(svgIcon, color: PrimaryColors.primary800, width: 24.w, height: 24.h),
            SizedBox(width: 10.w),
            TypographyStyles.body(
              text,
              color: PrimaryColors.primary800,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Divider(thickness: 1, color: GrayColors.gray200),
        ),
      ],
    );
  }

  Widget _componentRowText({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.height * 0.16,
          child: TypographyStyles.caption(
            label,
            color: GrayColors.gray500,
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          child: TypographyStyles.body(
            value,
            color: GrayColors.gray800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Helper untuk warna status
  Color _getStatusColor(PorterTransactionModel? transaction) {
    if (transaction == null) return GrayColors.gray400;

    switch (transaction.normalizedStatus) {
      case 'pending':
        return Colors.orange;
      case 'proses':
        return PrimaryColors.primary800;
      case 'selesai':
        return Colors.green;
      default:
        return GrayColors.gray400;
    }
  }

  // Helper untuk icon status
  IconData _getStatusIcon(PorterTransactionModel? transaction) {
    if (transaction == null) return Icons.info_outline;

    switch (transaction.normalizedStatus) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'proses':
        return Icons.directions_run;
      case 'selesai':
        return Icons.check_circle_outline;
      default:
        return Icons.info_outline;
    }
  }
}
