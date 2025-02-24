import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../_core/component/appbar/appbar_component.dart';

class TicketBookingStep3Screen extends StatefulWidget {
  const TicketBookingStep3Screen({super.key});

  @override
  State<TicketBookingStep3Screen> createState() => _TicketBookingStep3ScreenState();
}

class _TicketBookingStep3ScreenState extends State<TicketBookingStep3Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: ProgressAppbarComponent(
        title: 'Pesan Tiket',
        subTitle: 'Langkah 3 dari 4',
        onTab: () {
          Get.back();
        },
      ),
    );
  }
}