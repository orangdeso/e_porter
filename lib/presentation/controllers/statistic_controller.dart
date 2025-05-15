import 'package:e_porter/_core/utils/snackbar/snackbar_helper.dart';
import 'package:e_porter/domain/usecases/statistic_usecase.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class StatisticController extends GetxController {
  final StatisticUseCase useCase;
  final String porterId;

  final date = DateTime.now().obs;
  final month = DateTime.now().obs;
  final monthlyDateRange = ''.obs;

  final incoming = 0.obs;
  final inProgress = 0.obs;
  final completed = 0.obs;
  final revenue = 0.0.obs;
  final monthlyRevenue = 0.0.obs;

  Timer? _monthlyUpdateTimer;

  StatisticController({
    required this.useCase,
    required this.porterId,
  });

  @override
  void onInit() {
    super.onInit();
    _bindAllStreams();
    ever(date, (_) => _bindAllStreams());
    ever(month, (_) {
      _bindMonthlyStream();
      _updateMonthlyDateRange();
    });

    _updateMonthlyDateRange();
    _setupMonthlyUpdateTimer();
  }

  @override
  void onClose() {
    _monthlyUpdateTimer?.cancel();
    super.onClose();
  }

  void _setupMonthlyUpdateTimer() {
    _monthlyUpdateTimer?.cancel();

    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = nextMidnight.difference(now);

    _monthlyUpdateTimer = Timer(timeUntilMidnight, () {
      final currentMonth = DateTime.now();
      if (currentMonth.month != month.value.month || currentMonth.year != month.value.year) {
        month.value = currentMonth;
      }

      _setupMonthlyUpdateTimer();
    });
  }

  DateTime _getFirstDayOfMonth(DateTime month) {
    return DateTime(month.year, month.month, 1);
  }

  DateTime _getLastDayOfMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0);
  }

  void _updateMonthlyDateRange() {
    final firstDay = _getFirstDayOfMonth(month.value);
    final lastDay = _getLastDayOfMonth(month.value);

    final formatter = DateFormat('dd/MM/yyyy');
    final startDateStr = formatter.format(firstDay);
    final endDateStr = formatter.format(lastDay);

    monthlyDateRange.value = '$startDateStr - $endDateStr';
  }

  void _bindAllStreams() {
    incoming.bindStream(
      useCase.getIncomingOrders(porterId: porterId, date: date.value),
    );
    inProgress.bindStream(
      useCase.getInProgressOrders(porterId: porterId, date: date.value),
    );
    completed.bindStream(
      useCase.getCompletedOrders(porterId: porterId, date: date.value),
    );
    revenue.bindStream(
      useCase.getRevenue(porterId: porterId, date: date.value),
    );

    _bindMonthlyStream();
  }

  void _bindMonthlyStream() {
    try {
      monthlyRevenue.bindStream(useCase.getMonthlyRevenue(porterId: porterId, month: month.value).handleError((error) {
        print('Error fetching monthly revenue: $error');
        SnackbarHelper.showError('Koneksi Gagal', 'Tidak dapat memuat data pendapatan. Periksa koneksi internet Anda.');
        return 0.0;
      }));
    } catch (e) {
      print('Exception in bindMonthlyStream: $e');
      monthlyRevenue.value = 0.0; 
    }
  }

  void changeDate(DateTime newDate) => date.value = newDate;

  void changeMonth(DateTime newMonth) {
    month.value = newMonth;
  }

  void resetToCurrentMonth() {
    month.value = DateTime.now();
  }

  void previousMonth() {
    final current = month.value;
    month.value = DateTime(current.year, current.month - 1, 1);
  }

  void nextMonth() {
    final current = month.value;
    month.value = DateTime(current.year, current.month + 1, 1);
  }
}
