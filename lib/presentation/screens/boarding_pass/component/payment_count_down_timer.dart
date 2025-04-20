import 'dart:async';
import 'package:flutter/material.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentCountdownTimer extends StatefulWidget {
  final DateTime expiryTime;

  const PaymentCountdownTimer({
    Key? key,
    required this.expiryTime,
  }) : super(key: key);

  @override
  State<PaymentCountdownTimer> createState() => _PaymentCountdownTimerState();
}

class _PaymentCountdownTimerState extends State<PaymentCountdownTimer> {
  late Timer _timer;
  late Duration _remainingTime;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    if (widget.expiryTime.isAfter(now)) {
      _remainingTime = widget.expiryTime.difference(now);
    } else {
      _remainingTime = Duration.zero;
      _isExpired = true;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      
      setState(() {
        _calculateRemainingTime();
        if (_remainingTime.inSeconds <= 0) {
          _isExpired = true;
          _timer.cancel();
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: RedColors.red200,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TypographyStyles.caption(
            "Batas Pembayaran",
            color: RedColors.red600,
            fontWeight: FontWeight.w400,
          ),
          TypographyStyles.caption(
            _isExpired ? "Kedaluwarsa" : _formatDuration(_remainingTime),
            color: RedColors.red600,
          ),
        ],
      ),
    );
  }
}