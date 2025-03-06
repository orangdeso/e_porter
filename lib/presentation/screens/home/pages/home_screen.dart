import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_list_tile.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/home/component/profile_avatar.dart';
import 'package:e_porter/presentation/screens/home/component/summary_card.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;
  late final String role;
  final CarouselSliderController _carouselController = CarouselSliderController();

  final List<Widget> imageList = [
    Container(
      child: Image.asset(
        'assets/images/banner.png',
      ),
    ),
    Container(
      child: Image.asset(
        'assets/images/banner.png',
      ),
    )
  ];

  @override
  void initState() {
    super.initState();
    role = Get.arguments ?? 'penumpang';
  }

  @override
  Widget build(BuildContext context) {
    if (role == 'porter') {
      return _buildPorterUI();
    }
    return _buildPassengerUI();
  }

  Widget _buildPassengerUI() {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: HomeAppbarComponent(
        title: 'E-Porter',
        subtitle: 'Your Porter, Your Priority',
        backgroundColor: PrimaryColors.primary800,
        trailing: Flexible(
          child: SvgPicture.asset(
            'assets/images/ornamen.svg',
            height: 40,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: 60.h,
            width: double.infinity,
            color: PrimaryColors.primary800,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      strokeAlign: 1.w,
                      color: GrayColors.gray100,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        offset: const Offset(0, 4),
                        blurRadius: 14,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ProfileAvatar(
                            fullName: 'Muhammad Al Kahfi',
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TypographyStyles.body('Muhammad Al Kahfi'),
                                SizedBox(height: 2.h),
                                TypographyStyles.caption(
                                  'Jelajahi dunia dengan E-Porter',
                                  color: GrayColors.gray500,
                                  fontWeight: FontWeight.w400,
                                  maxlines: 1,
                                ),
                              ],
                            ),
                          ),
                          SvgPicture.asset('assets/icons/ic_notification.svg'),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      ButtonListTile(
                        onTab: () {
                          Get.toNamed(Routes.BOOKINGTICKETS);
                        },
                        titleText: 'Pesan Tiket',
                        subTitle: 'Jadwalkan penerbangan sekarang!',
                        imageAssets: 'assets/icons/ic_sent.svg',
                        backroundColor: GrayColors.gray100,
                        strokeColor: GrayColors.gray300,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                Container(
                  child: CarouselSlider(
                      items: imageList,
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 2.3,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        reverse: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      )),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imageList.asMap().entries.map(
                    (entry) {
                      return GestureDetector(
                        onTap: () => _carouselController.animateToPage(entry.key),
                        child: Container(
                          width: 8.w,
                          height: 8.h,
                          margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : PrimaryColors.primary800)
                                .withOpacity(_current == entry.key ? 0.9 : 0.4),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
                SizedBox(height: 32.h),
                TypographyStyles.h6(
                  'Layanan untuk Anda',
                  color: GrayColors.gray800,
                ),
                SizedBox(height: 4.h),
                TypographyStyles.caption(
                  'Layanan premium yang akan menemani Anda',
                  color: GrayColors.gray600,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPorterUI() {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppbar(
              context,
              nameAvatar: 'Muhammad Al Kahfi',
              nameUser: 'Muhammad Al Kahfi',
              subTitle: 'Selamat datang kembali Rekanku',
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TypographyStyles.h6('Ringkasan Hari ini', color: GrayColors.gray800),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          SummaryCard(
                            label: 'Pesanan Masuk',
                            value: '1000000000000000000000',
                            icon: CustomeIcons.PlaneLeftOutline(),
                          ),
                          SizedBox(width: 16.w),
                          SummaryCard(
                            label: 'Pesanan Berjalan',
                            value: '1000000000000000000000',
                            icon: CustomeIcons.PlaneLeftOutline(),
                          )
                        ],
                      ),
                      SizedBox(height: 16.w),
                      Row(
                        children: [
                          SummaryCard(
                            label: 'Pesanan Selesai',
                            value: '1000000000000000000000',
                            icon: CustomeIcons.PlaneLeftOutline(),
                          ),
                          SizedBox(width: 16.w),
                          SummaryCard(
                            label: 'Pendapatan',
                            value: 'Rp 500.000',
                            icon: CustomeIcons.PlaneLeftOutline(),
                          )
                        ],
                      ),
                      SizedBox(height: 32.w),
                      CustomeShadowCotainner(child: TypographyStyles.body('Mulai Antrian'))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildAppbar(
  BuildContext context, {
  required String nameAvatar,
  required String nameUser,
  required String subTitle,
  VoidCallback? onTap,
}) {
  return CustomeShadowCotainner(
    sizeRadius: 0.r,
    child: Row(
      children: [
        ProfileAvatar(fullName: nameAvatar),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypographyStyles.h6(nameUser, color: GrayColors.gray800),
              SizedBox(height: 4.h),
              TypographyStyles.caption(
                subTitle,
                color: GrayColors.gray600,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
        ZoomTapAnimation(
          child: IconButton(
            onPressed: onTap,
            icon: CustomeIcons.NotificationOutline(),
          ),
        )
      ],
    ),
  );
}
