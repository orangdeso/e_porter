import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/home/component/card_indicator.dart';
import 'package:e_porter/presentation/screens/home/component/card_seat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/button/button_fill.dart';
import '../../routes/app_rountes.dart';

class ChooseSeatScreen extends StatefulWidget {
  const ChooseSeatScreen({super.key});

  @override
  State<ChooseSeatScreen> createState() => _ChooseSeatScreenState();
}

class _ChooseSeatScreenState extends State<ChooseSeatScreen> {
  final List<bool> selectedSeats = List.generate(3, (_) => false);
  // late ScrollController _scrollController;

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController = ScrollController();
  // }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: CustomeAppbarComponent(
        valueDari: 'Pilih Kursi',
        valueKe: null,
        date: 'Yogyakarta - Lombok',
        passenger: '2',
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
          child: CustomScrollView(
        // controller: _scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: GrayColors.gray50,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            expandedHeight: 220.h,
            flexibleSpace: FlexibleSpaceBar(
              background: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCardFlight("YIA", "LOP", "Economy", "5j 40m"),
                      SizedBox(height: 20.h),
                      SizedBox(
                        height: 84.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: _buildPassengerCard('Ahmad', 'Economy', '10F', index),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverHeaderDelegate(
              minHeight: 50.h,
              maxHeight: 50.h,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                alignment: Alignment.centerLeft,
                child: _buildCardInformationStatus(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: CustomeShadowCotainner(
              sizeRadius: 0.r,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCardSeat(context, label: 'A'),
                      _buildCardSeat(context, label: 'B'),
                      _buildCardSeat(context, label: 'C'),
                      SizedBox(width: 16.w),
                      _buildNumberSeat(context, label: '1'),
                      _buildCardSeat(context, label: 'D'),
                      _buildCardSeat(context, label: 'E'),
                      _buildCardSeat(context, label: 'F'),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      )),
      bottomNavigationBar: CustomeShadowCotainner(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: ZoomTapAnimation(
          child: ButtonFill(
            text: 'Lanjutkan',
            textColor: Colors.white,
            onTap: () {
              Get.toNamed(Routes.TICKETBOOKINGSTEP2);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardFlight(String departureCode, String arrivalCode, String kelas, String duration) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h),
      child: CustomeShadowCotainner(
        child: Row(
          children: [
            SvgPicture.asset('assets/images/citilink.svg', width: 40.w, height: 10.h),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TypographyStyles.body(departureCode, color: GrayColors.gray800, letterSpacing: 0.2),
                    SizedBox(width: 10.w),
                    CustomeIcons.RightOutline(color: GrayColors.gray800, size: 14),
                    SizedBox(width: 10.w),
                    TypographyStyles.body(arrivalCode, color: GrayColors.gray800, letterSpacing: 0.2),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    TypographyStyles.small(
                      kelas,
                      color: GrayColors.gray600,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(width: 10.w),
                    CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
                    SizedBox(width: 10.w),
                    TypographyStyles.small(
                      duration,
                      color: GrayColors.gray600,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerCard(String name, String kelas, String seat, int index) {
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: () {
          setState(() {
            for (int i = 0; i < selectedSeats.length; i++) {
              selectedSeats[i] = false;
            }
            selectedSeats[index] = true;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selectedSeats[index] ? PrimaryColors.primary800 : GrayColors.gray200,
              width: 1.w,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypographyStyles.body(
                name,
                color: GrayColors.gray800,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 2.h),
              TypographyStyles.caption(
                '${kelas} / Kursi ${seat}',
                color: GrayColors.gray600,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardInformationStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CardIndicator(
          text: 'Kosong',
          border: Border.all(width: 1.w, color: PrimaryColors.primary800),
        ),
        SizedBox(width: 32.w),
        CardIndicator(
          text: 'Terisi',
          boxColor: GrayColors.gray300,
        ),
        SizedBox(width: 32.w),
        CardIndicator(
          text: 'Dipilih',
          textColor: PrimaryColors.primary800,
          boxColor: PrimaryColors.primary900,
        )
      ],
    );
  }

  Widget _buildCardSeat(
    BuildContext context, {
    required label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            child: TypographyStyles.body(label, color: GrayColors.gray800, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6.h),
          ListView.builder(
            itemCount: 20,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: CardSeat(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNumberSeat(
    BuildContext context, {
    required label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            child: TypographyStyles.body('', color: Colors.white, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6.h),
          ListView.builder(
            itemCount: 20,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  child: TypographyStyles.body(label, color: GrayColors.gray800, fontWeight: FontWeight.w500),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32.w,
          height: 32.h,
          child: TypographyStyles.body('A', color: GrayColors.gray800, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 10.w),
        Container(
          width: 32.w,
          height: 32.h,
          child: TypographyStyles.body('B', color: GrayColors.gray800, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 10.w),
        Container(
          width: 32.w,
          height: 32.h,
          child: TypographyStyles.body('C', color: GrayColors.gray800, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 106.w),
        Container(
          width: 32.w,
          height: 32.h,
          child: TypographyStyles.body('D', color: GrayColors.gray800, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 10.w),
        Container(
          width: 32.w,
          height: 32.h,
          child: TypographyStyles.body('E', color: GrayColors.gray800, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 10.w),
        Container(
          width: 32.w,
          height: 32.h,
          child: TypographyStyles.body('F', color: GrayColors.gray800, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
