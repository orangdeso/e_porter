import 'dart:developer';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/domain/models/transaction_model.dart';
import 'package:e_porter/domain/models/transaction_porter_model.dart';
import 'package:e_porter/presentation/controllers/history_controller.dart';
import 'package:e_porter/presentation/controllers/transaction_porter_controller.dart';
import 'package:e_porter/presentation/screens/boarding_pass/component/card_history_porter.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../_core/component/appbar/appbar_component.dart';

class HistoryPorterScreen extends StatefulWidget {
  const HistoryPorterScreen({super.key});

  @override
  State<HistoryPorterScreen> createState() => _HistoryPorterScreenState();
}

class _HistoryPorterScreenState extends State<HistoryPorterScreen> {
  final TransactionPorterController _porterController = Get.find<TransactionPorterController>();
  final HistoryController _historyController = Get.find<HistoryController>();
  final Map<String, TransactionModel> _ticketTransactionCache = {};

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat _timeFormat = DateFormat('HH:mm');
  final NumberFormat _priceFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // Future<List<PorterTransactionModel>> _loadPorterTransactionHistory() async {
  //   try {
  //     if (_userId.isEmpty) return [];

  //     // Dapatkan ID semua transaksi porter
  //     final transactionIds = await _porterController.getPorterTransactionIds(_userId);

  //     // Muat data untuk setiap ID transaksi
  //     final transactions = <PorterTransactionModel>[];

  //     for (final id in transactionIds) {
  //       final txData = await _porterController.getPorterTransactionById(id);
  //       if (txData != null) {
  //         transactions.add(PorterTransactionModel.fromJson(txData, id));
  //       }
  //     }

  //     return transactions;
  //   } catch (e) {
  //     log('Error loading porter transaction history: $e');
  //     return [];
  //   }
  // }

  Future<TransactionModel?> _loadTicketTransaction(String ticketId, String transactionId) async {
    final cacheKey = "$ticketId-$transactionId";
    if (_ticketTransactionCache.containsKey(cacheKey)) {
      return _ticketTransactionCache[cacheKey];
    }

    try {
      if (ticketId.isEmpty || transactionId.isEmpty) {
        return null;
      }

      final transaction = await _historyController.getTransactionFromFirestore(ticketId, transactionId);

      if (transaction != null) {
        _ticketTransactionCache[cacheKey] = transaction;
      }

      return transaction;
    } catch (e) {
      log('Error loading ticket transaction: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: GrayColors.gray50,
        appBar: SimpleAppbarComponent(
          title: 'Riwayat Transaksi',
          subTitle: 'Semua aktivitas transaksi aktif ditampilkan dihalaman ini',
        ),
        body: Column(
          children: [
            _buildLoadingIndicator(),
            _buildTabBar(),
            _buildErrorMessage(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTransactionList('pending'),
                  _buildTransactionList('proses'),
                  _buildTransactionList('selesai'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Indikator loading
  Widget _buildLoadingIndicator() {
    return Obx(() => _porterController.isLoading.value
        ? LinearProgressIndicator(
            backgroundColor: PrimaryColors.primary100,
            valueColor: AlwaysStoppedAnimation<Color>(PrimaryColors.primary800),
          )
        : const SizedBox.shrink());
  }

  // Tab bar
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        labelColor: PrimaryColors.primary800,
        unselectedLabelColor: GrayColors.gray400,
        indicatorColor: PrimaryColors.primary800,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Pending'),
          Tab(text: 'Proses'),
          Tab(text: 'Selesai'),
        ],
      ),
    );
  }

  // Pesan error
  Widget _buildErrorMessage() {
    return Obx(() {
      if (_porterController.error.value.isEmpty) {
        return const SizedBox.shrink();
      }

      // Customisasi pesan error untuk lebih user-friendly
      String errorMessage = _porterController.error.value;
      if (errorMessage.contains('Porter tidak ditemukan')) {
        return Container(
          padding: EdgeInsets.all(8.w),
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange, size: 20.w),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Menampilkan riwayat transaksi yang telah selesai',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      // Error lainnya
      return Container(
        padding: EdgeInsets.all(8.w),
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 20.w),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red[800],
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Daftar transaksi
  Widget _buildTransactionList(String statusFilter) {
    return Obx(() {
      // Jika sedang loading, tampilkan indikator
      if (_porterController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // Ambil semua transaksi dari controller
      final allTransactions = _porterController.transactions;

      // Log untuk debug
      log('Semua transaksi: ${allTransactions.length}');

      // Filter berdasarkan status
      final filteredTransactions = allTransactions.where((tx) => tx.normalizedStatus == statusFilter).toList();

      log('Transaksi dengan status $statusFilter: ${filteredTransactions.length}');

      // Jika tidak ada transaksi, tampilkan pesan kosong
      if (filteredTransactions.isEmpty) {
        // Jika ada error tapi tidak ada transaksi
        if (_porterController.error.value.contains('Porter tidak ditemukan') && statusFilter == 'selesai') {
          // Tampilkan pesan yang lebih positif
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 48.h, color: Colors.grey[400]),
                SizedBox(height: 16.h),
                TypographyStyles.body(
                  'Tidak ada riwayat transaksi selesai',
                  color: GrayColors.gray600,
                ),
                SizedBox(height: 8.h),
                TypographyStyles.caption(
                  'Riwayat akan muncul setelah Anda menyelesaikan transaksi',
                  color: GrayColors.gray500,
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: () => _porterController.refreshTransactions(),
                  icon: Icon(Icons.refresh, size: 16.h),
                  label: const Text('Muat Ulang'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PrimaryColors.primary800,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return _buildEmptyTransactionMessage(statusFilter);
      }

      // Jika ada transaksi, tampilkan daftar
      return RefreshIndicator(
        onRefresh: () => _porterController.refreshTransactions(),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: filteredTransactions.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) => _buildTransactionItem(filteredTransactions[index]),
        ),
      );
    });
  }

  // Pesan tidak ada transaksi
  Widget _buildEmptyTransactionMessage(String statusFilter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TypographyStyles.body(
            'Tidak ada transaksi ${statusFilter.capitalizeFirst}',
            color: GrayColors.gray600,
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            // Perbaiki ini untuk memanggil refreshTransactions di controller
            onPressed: () => _porterController.refreshTransactions(),
            icon: Icon(Icons.refresh, size: 16.h),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: PrimaryColors.primary800,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Item transaksi
  Widget _buildTransactionItem(PorterTransactionModel transaction) {
    log('Building item for transaction: ${transaction.id}, status: ${transaction.status}');
    return FutureBuilder<TransactionModel?>(
      future: _loadTicketTransaction(transaction.ticketId, transaction.transactionId),
      builder: (context, snapshot) {
        String passengerName = transaction.idPassenger;
        String passengerPhone = '-';
        double price = 0;
        String porter1 = 'Porter';
        String? porter2 = null;
        String? porter3 = null;

        if (snapshot.hasData && snapshot.data != null) {
          final ticketTransaction = snapshot.data!;
          passengerName = ticketTransaction.userDetails['name'] ?? transaction.idPassenger;
          passengerPhone = ticketTransaction.userDetails['phone'] ?? '-';

          if (ticketTransaction.porterServiceDetails != null) {
            price = 0;
            if (ticketTransaction.porterServiceDetails!.containsKey('arrival') &&
                ticketTransaction.porterServiceDetails!['arrival'] is Map<String, dynamic> &&
                ticketTransaction.porterServiceDetails!['arrival'].containsKey('price')) {
              price += (ticketTransaction.porterServiceDetails!['arrival']['price'] as num).toDouble();
              porter1 = ticketTransaction.porterServiceDetails!['arrival']['name'] ?? 'Porter';
            }

            if (ticketTransaction.porterServiceDetails!.containsKey('departure') &&
                ticketTransaction.porterServiceDetails!['departure'] is Map<String, dynamic> &&
                ticketTransaction.porterServiceDetails!['departure'].containsKey('price')) {
              price += (ticketTransaction.porterServiceDetails!['departure']['price'] as num).toDouble();
              porter2 = ticketTransaction.porterServiceDetails!['departure']['name'];
            }

            if (ticketTransaction.porterServiceDetails!.containsKey('transit') &&
                ticketTransaction.porterServiceDetails!['transit'] is Map<String, dynamic> &&
                ticketTransaction.porterServiceDetails!['transit'].containsKey('price')) {
              price += (ticketTransaction.porterServiceDetails!['transit']['price'] as num).toDouble();
              porter3 = ticketTransaction.porterServiceDetails!['transit']['name'];
            }

            log('Total porter price: $price');
          }
        }

        return CardHistoryPorter(
          namePassenger: passengerName,
          tlpnPassenger: passengerPhone,
          lokasiPassenger: transaction.locationPassenger,
          status: transaction.normalizedStatus.capitalizeFirst!,
          date: _dateFormat.format(transaction.createdAt),
          time: _timeFormat.format(transaction.createdAt),
          porter1: porter1,
          porter2: porter2,
          porter3: porter3,
          price: _priceFormatter.format(price),
          statusColor: _getStatusColor(transaction.normalizedStatus),
          onTap: () {
            log('ID Transaction Porter: ${transaction.id}');
            Get.toNamed(Routes.DETAILHISTORYPORTER, arguments: {
              'transactionPorterId': transaction.id,
              'ticketId': transaction.ticketId,
              'ticketTransactionId': transaction.transactionId,
            });
          },
        );
      },
    );
  }

  // Warna status
  Color _getStatusColor(String status) {
    switch (status) {
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
}
