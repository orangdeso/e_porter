import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BookingTickets extends StatefulWidget {
  const BookingTickets({super.key});

  @override
  State<BookingTickets> createState() => _BookingTicketsState();
}

class _BookingTicketsState extends State<BookingTickets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Pesan Tiket',
        backgroundColors: Colors.white,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
      ),
    );
  }
}
