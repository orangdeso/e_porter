import 'package:e_porter/_core/component/dotted/dashed_line_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/boarding_pass/component/card_details_passenger.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/appbar/appbar_component.dart';
import '../../../../_core/component/button/button_fill.dart';
import '../../../../_core/component/card/custome_shadow_cotainner.dart';
import '../../home/component/title_show_modal.dart';

class DetailTicketScreen extends StatelessWidget {
  const DetailTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Detail Tiket',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TypographyStyles.caption(
                  "Kode Booking Maskapai",
                  color: GrayColors.gray500,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 6.h),
                TypographyStyles.body("I2L8JRL", color: GrayColors.gray800),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: CustomDashedLine(),
                ),
                Row(
                  children: [
                    TypographyStyles.body("Citilink (103)", color: GrayColors.gray800),
                    SizedBox(width: 10.w),
                    SvgPicture.asset('assets/images/citilink.svg', width: 40.w, height: 10.h),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    TypographyStyles.small("Fast Track (FT)", color: GrayColors.gray600, fontWeight: FontWeight.w400),
                    SizedBox(width: 10.w),
                    CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
                    SizedBox(width: 10.w),
                    TypographyStyles.small("Economy", color: GrayColors.gray600, fontWeight: FontWeight.w400),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TypographyStyles.caption("12:20", color: GrayColors.gray800),
                        TypographyStyles.small("Sen, 27 Jan", color: GrayColors.gray600, fontWeight: FontWeight.w400),
                        SizedBox(height: 20.h),
                        TypographyStyles.small("5j 40m", color: GrayColors.gray600, fontWeight: FontWeight.w400),
                        SizedBox(height: 20.h),
                        TypographyStyles.caption("12:20", color: GrayColors.gray800),
                        TypographyStyles.small("Sen, 27 Jan", color: GrayColors.gray600, fontWeight: FontWeight.w400),
                      ],
                    ),
                    SizedBox(width: 20.w),
                    SvgPicture.asset('assets/images/garis.svg', height: 100.h),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TypographyStyles.caption("Yogyakarta (YIA)", color: GrayColors.gray800),
                          TypographyStyles.caption(
                            "Bandar YIA, Terminal Domestic",
                            color: GrayColors.gray600,
                            fontWeight: FontWeight.w400,
                            maxlines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 58.h),
                          TypographyStyles.caption("Lombok (LOP)", color: GrayColors.gray800),
                          TypographyStyles.caption(
                            "Bandar Zainuddin Abdul Madjid, Terminal Domestic",
                            color: GrayColors.gray600,
                            fontWeight: FontWeight.w400,
                            maxlines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: CustomDashedLine(),
                ),
                TypographyStyles.h6("Detail Penumpang", color: GrayColors.gray800),
                SizedBox(height: 20.h),
                ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CardDetailsPassenger(
                      name: 'AHMAD CHOIRUL UMAM ALI',
                      typeId: 'KTP',
                      noId: '3571••••••••••03',
                      seatClass: 'Economy',
                      numberSeat: '10 F',
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: ButtonFill(
          text: 'Cetak Boarding Pass',
          textColor: Colors.white,
          onTap: () {
            Get.bottomSheet(
              backgroundColor: Colors.white,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                child: Wrap(
                  children: [
                    TitleShowModal(text: 'Cetak Boarding Pass'),
                    SizedBox(height: 30.h),
                    ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 16.h),
                          child: _buildCetakBoardingPass(
                            context,
                            name: 'AHMAD CHOIRUL UMAM',
                            typeId: 'KTP',
                            noId: '3571••••••••••03',
                            onTap: () {
                              Get.toNamed(Routes.PRINTBOARDINGPASS);
                            },
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCetakBoardingPass(
    BuildContext context, {
    required String name,
    required String typeId,
    required String noId,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: GrayColors.gray50,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(width: 1.w, color: GrayColors.gray200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypographyStyles.body(name, color: GrayColors.gray800),
              SizedBox(height: 4.h),
              TypographyStyles.caption("${typeId} - ${noId}", color: GrayColors.gray500, fontWeight: FontWeight.w400),
            ],
          ),
          ZoomTapAnimation(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: PrimaryColors.primary800,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TypographyStyles.small('Cetak Sekarang', color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
