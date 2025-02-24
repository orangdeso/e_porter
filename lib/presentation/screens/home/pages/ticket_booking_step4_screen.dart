import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../_core/component/appbar/appbar_component.dart';

class TicketBookingStep4Screen extends StatefulWidget {
  const TicketBookingStep4Screen({super.key});

  @override
  State<TicketBookingStep4Screen> createState() => _TicketBookingStep4ScreenState();
}

class _TicketBookingStep4ScreenState extends State<TicketBookingStep4Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: ProgressAppbarComponent(
        title: 'Pesan Tiket',
        subTitle: 'Langkah 4 dari 4',
        onTab: () {
          Get.back();
        },
      ),
    );
  }
}