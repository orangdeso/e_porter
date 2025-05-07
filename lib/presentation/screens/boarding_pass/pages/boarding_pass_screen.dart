import 'dart:async';
import 'dart:developer';
import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/utils/formatter/date_helper.dart';
import 'package:e_porter/presentation/controllers/history_controller.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../_core/service/preferences_service.dart';
import '../../../../_core/utils/map_helper.dart';
import '../../../../domain/models/transaction_model.dart';
import '../component/card_boarding_pass.dart';

class BoardingPassScreen extends StatefulWidget {
  const BoardingPassScreen({super.key});

  @override
  State<BoardingPassScreen> createState() => _BoardingPassScreenState();
}

class _BoardingPassScreenState extends State<BoardingPassScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final HistoryController _historyController = Get.find<HistoryController>();

  Timer? _refreshTimer;

  bool isLoading = true;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();

    _refreshTimer = Timer.periodic(Duration(seconds: 10), (_) {
      _checkExpiredTransactions();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkExpiredTransactions() async {
    if (userId.isNotEmpty) {
      final now = DateTime.now();
      final expiredTransactions =
          _historyController.pendingTransactions.where((tx) => tx.expiryTime.isBefore(now)).toList();

      if (expiredTransactions.isNotEmpty) {
        await _historyController.checkExpiredPendingTransactions();
        setState(() {});
      }
    }
  }

  Future<void> _loadUserData() async {
    final userData = await PreferencesService.getUserData();
    if (userData != null) {
      userId = userData.uid;
      _historyController.initStreams(userId);
    } else {
      _historyController.isLoading.value = false;
    }
    setState(() {
      isLoading = false;
    });
  }

  String? _getPorterServiceInfo(TransactionModel transaction) {
    if (transaction.porterServiceDetails == null || transaction.porterServiceDetails!.isEmpty) {
      return null;
    }
    final porterService = transaction.porterServiceDetails!;

    final keys = porterService.keys.toList();
    if (keys.isEmpty) {
      return null;
    }

    keys.sort();
    if (keys.length == 1) {
      final type = _getPorterTypeInIndonesian(keys.first);
      return type;
    }
    final firstType = _getPorterTypeInIndonesian(keys.first);
    return "$firstType & ${keys.length - 1}";
  }

  String _getPorterTypeInIndonesian(String type) {
    switch (type) {
      case 'arrival':
        return 'Kedatangan';
      case 'departure':
        return 'Keberangkatan';
      case 'transit':
        return 'Transit';
      default:
        return type;
    }
  }

  List<String> _getPorterServiceNames(TransactionModel transaction) {
    List<String> serviceNames = [];

    if (transaction.porterServiceDetails == null || transaction.porterServiceDetails!.isEmpty) {
      return serviceNames;
    }

    transaction.porterServiceDetails!.forEach((serviceType, serviceDetails) {
      if (serviceDetails is Map && serviceDetails.containsKey('name')) {
        String serviceName = serviceDetails['name'] as String? ?? '';
        if (serviceName.isNotEmpty) {
          serviceNames.add(serviceName);
        }
      }
    });

    return serviceNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: SimpleAppbarComponent(
        title: 'Boarding Pass',
        subTitle: 'Semua boarding pass pesawat yang aktif ditampilkan dihalaman ini',
        onTab: () {
          Get.toNamed(Routes.TRANSACTIONHISTORY);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: PrimaryColors.primary800,
                unselectedLabelColor: GrayColors.gray400,
                indicatorColor: PrimaryColors.primary800,
                tabs: const [
                  Tab(text: 'Belum dibayar'),
                  Tab(text: 'Sedang aktif'),
                ],
              ),
            ),
            Obx(() => _historyController.isCheckingExpiry.value
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    color: Colors.amber.shade100,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber.shade800),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Memeriksa status transaksi...",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.amber.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink()),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Obx(() {
                  if (_historyController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_historyController.pendingTransactions.isEmpty && _historyController.activeTransactions.isEmpty) {
                    return const Center(
                      child: Text(
                        "Tidak ada transaksi",
                        style: TextStyle(
                          fontSize: 16,
                          color: GrayColors.gray500,
                        ),
                      ),
                    );
                  }

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTransactionList(_historyController.pendingTransactions, false),
                      _buildTransactionList(_historyController.activeTransactions, true),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionModel> transactions, bool isActive) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada transaksi",
          style: TextStyle(
            fontSize: 16,
            color: GrayColors.gray500,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _historyController.refreshTransactions(userId);
        _historyController.checkExpiredPendingTransactions();
      },
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];

          final flightDetails = transaction.flightDetails;
          final bandaraDetails = transaction.bandaraDetails;

          final porterServiceInfo = _getPorterServiceInfo(transaction);
          final porterServiceNames = _getPorterServiceNames(transaction);

          final departureTime = DateFormatterHelper.formatFlightTime(transaction.flightDetails['departureTime']);
          final arrivalTime = DateFormatterHelper.formatFlightTime(transaction.flightDetails['arrivalTime']);
          final departureDate = DateFormatterHelper.formatFlightDate(transaction.flightDetails['departureTime']);
          final arrivalDate = DateFormatterHelper.formatFlightDate(transaction.flightDetails['arrivalTime']);
          final duration = DateFormatterHelper.calculateFlightDuration(
            transaction.flightDetails['departureTime'],
            transaction.flightDetails['arrivalTime'],
          );

          final departurePlane = MapHelper.getNestedValue(bandaraDetails, ['departure', 'name'], '');
          final arrivalPlane = MapHelper.getNestedValue(bandaraDetails, ['arrival', 'name'], '');

          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: CardBoardingPass(
              isActive: isActive,
              idBooking: transaction.idBooking,
              opsiFlight: porterServiceInfo,
              expiryTime: transaction.expiryTime,
              airlines: flightDetails['airLines'],
              codeAirlines: flightDetails['code'],
              logo: flightDetails['airlineLogo'],
              servicePorter: porterServiceNames,
              flightClass: flightDetails['flightClass'],
              passenger: transaction.passenger,
              departureTime: departureTime,
              arrivalTime: arrivalTime,
              departureDate: departureDate,
              arrivalDate: arrivalDate,
              duration: duration,
              departureCity: flightDetails['cityDeparture'],
              arrivalCity: flightDetails['cityArrival'],
              departureCode: flightDetails['codeDeparture'],
              arrivalCode: flightDetails['codeArrival'],
              departurePlane: departurePlane,
              arrivalPlane: arrivalPlane,
              onTap: () {
                final argument = {
                  'id_transaction': transaction.id,
                  'id_ticket': transaction.ticketId,
                };
                log('Arrival Time: $arrivalTime');
                log('Departure Time: $departureTime');

                Get.toNamed(Routes.DETAILTICKET, arguments: argument);
              },
            ),
          );
        },
      ),
    );
  }
}
