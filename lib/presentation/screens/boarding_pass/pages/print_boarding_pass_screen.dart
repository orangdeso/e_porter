import 'package:barcode_widget/barcode_widget.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/dotted/dashed_line_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/home/component/card_tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../_core/component/appbar/appbar_component.dart';

class PrintBoardingPassScreen extends StatelessWidget {
  const PrintBoardingPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Cetak Boarding Pass',
        textColor: Colors.white,
        backgroundColors: PrimaryColors.primary800,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomeShadowCotainner(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TypographyStyles.caption(
                            'Kode Booking Maskapai',
                            color: GrayColors.gray500,
                            fontWeight: FontWeight.w400,
                          ),
                          TypographyStyles.h6('text', color: GrayColors.gray800),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(thickness: 1, color: GrayColors.gray200),
                      ),
                      CardTickets(
                        withContainer: false,
                        showFooter: false,
                        departureCity: 'departureCity',
                        date: 'date',
                        arrivalCity: 'arrivalCity',
                        departureCode: 'YIA',
                        arrivalCode: 'LOP',
                        departureTime: 'departureTime',
                        arrivalTime: 'arrivalTime',
                        duration: 'duration',
                        seatClass: 'seatClass',
                        price: 'price',
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(thickness: 1, color: GrayColors.gray200),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildColumnText(context, label: 'Layanan', value: 'value'),
                          _buildColumnText(context, label: 'Class', value: 'value'),
                          _buildColumnText(context, label: 'Gate', value: 'value'),
                          _buildColumnText(context, label: 'Seat', value: 'value'),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: CustomDashedLine(),
                      ),
                      _buildBarcode(context, barcodeData: 'PK230222BE143')
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColumnText(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TypographyStyles.small(label, color: GrayColors.gray500, fontWeight: FontWeight.w400),
        TypographyStyles.caption(
          value,
          color: GrayColors.gray800,
          maxlines: 1,
        )
      ],
    );
  }

  Widget _buildBarcode(BuildContext context, {required String barcodeData}) {
    return Column(
      children: [
        BarcodeWidget(
          barcode: Barcode.code128(),
          data: barcodeData,
          height: 80.h,
          drawText: false,
        ),
        SizedBox(height: 10.h),
        TypographyStyles.small(barcodeData, color: GrayColors.gray800, fontWeight: FontWeight.w400)
      ],
    );
  }
}
