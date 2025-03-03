import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/home/component/footer_price.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../_core/component/appbar/appbar_component.dart';
import '../component/card_flight_information.dart';

class TicketBookingStep3Screen extends StatefulWidget {
  const TicketBookingStep3Screen({super.key});

  @override
  State<TicketBookingStep3Screen> createState() => _TicketBookingStep3ScreenState();
}

class _TicketBookingStep3ScreenState extends State<TicketBookingStep3Screen> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;

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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardFlightInformation(
                    date: "Sen, 27 Jan 2025",
                    time: "12.20 - 06.00 AM",
                    departureCity: "Yogyakarta",
                    arrivalCity: "Lombok",
                    plane: "Citilink (103)",
                    seatClass: "Economy",
                    passenger: "2",
                  ),
                  SizedBox(height: 32.h),
                  TypographyStyles.h6("Layanan Porter", color: GrayColors.gray800),
                  SizedBox(height: 10.h),
                  TypographyStyles.caption(
                    "Silahkan pilih opsi penerbangan untuk mencari layanan porter yang cocok untuk perjalanan Anda",
                    color: GrayColors.gray600,
                    fontWeight: FontWeight.w400,
                    maxlines: 3,
                  ),
                  SizedBox(height: 16.h),
                  _buildCheckBox(
                    context,
                    label: "Kedatangan",
                    Widget: CustomeIcons.AirplaneLandingOutline(color: Colors.white),
                    value: _isChecked1,
                    onTap: (bool? value) {
                      setState(() {
                        _isChecked1 = value ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 10.h),
                  _buildCheckBox(
                    context,
                    label: "Keberangkatan",
                    Widget: CustomeIcons.AirplaneTakeOffOutline(color: Colors.white),
                    value: _isChecked2,
                    onTap: (bool? value) {
                      setState(() {
                        _isChecked2 = value ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 10.h),
                  _buildCheckBox(
                    context,
                    label: "Transit",
                    Widget: CustomeIcons.TransitOutline(color: Colors.white),
                    value: _isChecked3,
                    onTap: (bool? value) {
                      setState(() {
                        _isChecked3 = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: FooterPrice(
          price: "1.450.000",
          labelText: "Pesanan",
          labelButton: "Lanjut",
          onTap: () {
            Get.toNamed(Routes.TICKETBOOKINGSTEP4);
          },
        ));
  }

  Widget _buildCheckBox(
    BuildContext context, {
    required label,
    required Widget,
    required value,
    required onTap,
  }) {
    return CustomeShadowCotainner(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      child: CheckboxListTile(
        activeColor: PrimaryColors.primary800,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: PrimaryColors.primary800,
              child: Widget,
            ),
            SizedBox(width: 16.w),
            TypographyStyles.caption(
              label,
              color: GrayColors.gray800,
              fontWeight: FontWeight.w500,
            )
          ],
        ),
        value: value,
        onChanged: onTap,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
