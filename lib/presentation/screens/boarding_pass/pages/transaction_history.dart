import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/presentation/screens/boarding_pass/component/card_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../_core/component/appbar/appbar_component.dart';

class transactionHistory extends StatefulWidget {
  const transactionHistory({super.key});

  @override
  State<transactionHistory> createState() => _transactionHistoryState();
}

class _transactionHistoryState extends State<transactionHistory> {
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
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: CardTransaction(),
              );
            },
          ),
        ),
      ),
    );
  }
}
