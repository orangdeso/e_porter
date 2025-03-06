import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/home/component/footer_price.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../_core/component/appbar/appbar_component.dart';
import '../../../../_core/component/icons/icons_library.dart';
import '../component/card_flight_information.dart';

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
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CardFlightInformation(
                    date: "Sen, 27 Jan 2025",
                    time: "12.20 - 06.00 AM",
                    departureCity: "Yogyakarta",
                    arrivalCity: "Lombok",
                    plane: "Citilink (103)",
                    seatClass: "Economy",
                    servicePorter: "Fast Track (FT)",
                    passenger: "2",
                  ),
                ),
                SizedBox(height: 32.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TypographyStyles.h6("Rincian Pesanan", color: GrayColors.gray800),
                ),
                SizedBox(height: 20.h),
                CustomeShadowCotainner(
                    sizeRadius: 0.r,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            TypographyStyles.body(
                              "Citilink (103)",
                              color: GrayColors.gray800,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(width: 10.w),
                            SvgPicture.asset('assets/images/citilink.svg', width: 40.w, height: 10.h),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            TypographyStyles.small(
                              "Fast Track (FT)",
                              color: GrayColors.gray600,
                              letterSpacing: 0.2,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(width: 10.w),
                            CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
                            SizedBox(width: 10.w),
                            TypographyStyles.small("Economy", color: GrayColors.gray600, fontWeight: FontWeight.w400),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            TypographyStyles.caption(
                              "Rp 1.200.000",
                              color: GrayColors.gray600,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(width: 8.w),
                            TypographyStyles.small("x 2", color: GrayColors.gray600, fontWeight: FontWeight.w400)
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Divider(thickness: 1.w, color: GrayColors.gray300),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TypographyStyles.caption(
                              "Total Pesanan",
                              color: GrayColors.gray600,
                              fontWeight: FontWeight.w400,
                            ),
                            TypographyStyles.body(
                              "Rp 2.400.000",
                              color: GrayColors.gray600,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        _buildRowText(context, text: "Layanan porter (Fast Track)", valueText: "50.000"),
                        SizedBox(height: 2.h),
                        _buildRowText(context, text: "Biaya layanan", valueText: "10.000"),
                      ],
                    ))
              ],
            ),
          ),
        )),
        bottomNavigationBar: FooterPrice(
          labelText: "Pembayaran",
          price: "1.450.000",
          labelButton: "Buat Pesanan",
          iconButton: CustomeIcons.ProtectOutline(color: Colors.white),
          onTap: () {
            Get.toNamed(Routes.PAYMENT);
          },
        ));
  }

  Widget _buildRowText(
    BuildContext context, {
    required String text,
    required String valueText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TypographyStyles.caption(
          text,
          color: GrayColors.gray600,
          fontWeight: FontWeight.w400,
        ),
        TypographyStyles.caption(
          "Rp ${valueText}",
          color: GrayColors.gray600,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
