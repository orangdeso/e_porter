// ignore_for_file: deprecated_member_use

import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_list_tile.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:e_porter/_core/component/text_field/text_input/text_field_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/_core/service/preferences_service.dart';
import 'package:e_porter/presentation/controllers/porter_queue_controller.dart';
import 'package:e_porter/presentation/screens/home/component/card_service_porter.dart';
import 'package:e_porter/presentation/screens/home/component/profile_avatar.dart';
import 'package:e_porter/presentation/screens/home/component/summary_card.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/utils/snackbar/snackbar_helper.dart';
import '../../../../domain/models/user_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;
  late final String role;
  late Future<UserData?> _userDataFuture;
  late PorterQueueController _porterQueueController;
  final CarouselSliderController _carouselController = CarouselSliderController();
  final TextEditingController _locationController = TextEditingController();

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
    _userDataFuture = PreferencesService.getUserData();

    if (role == 'porter') {
      _porterQueueController = Get.find<PorterQueueController>();
    }
  }

  Future<void> _handlePorterQueueCreation() async {
    final lokasiPorter = await _showLocationInputDialog();
    if (lokasiPorter == null || lokasiPorter.trim().isEmpty) return;

    try {
      final userData = await PreferencesService.getUserData();
      if (userData?.uid == null) {
        SnackbarHelper.showError(
          'Gagal',
          'User ID tidak ditemukan. Silakan login kembali.',
        );
        return;
      }

      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }

      _showLoadingDialog();

      await _porterQueueController.createPorterQueue(
        userData!.uid,
        lokasiPorter,
      );

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      SnackbarHelper.showSuccess(
        'Berhasil',
        'Anda telah masuk dalam antrian porter',
      );

      setState(() {});
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      SnackbarHelper.showError(
        'Gagal',
        'Gagal masuk antrian porter: ${e.toString()}',
      );
    }
  }

  Future<void> _handleStopPorterQueue() async {
    try {
      final userData = await PreferencesService.getUserData();
      final validUserId = await _porterQueueController.validateAndGetUserId(userData?.uid);
      if (validUserId == null) {
        SnackbarHelper.showError(
          'Gagal',
          _porterQueueController.error.value,
        );
        return;
      }

      if (_porterQueueController.currentPorter.value == null) {
        SnackbarHelper.showError(
          'Gagal',
          'Tidak ada antrian porter yang aktif.',
        );
        return;
      }
      final porterId = _porterQueueController.currentPorter.value!.id!;
      final canProceed = await _porterQueueController.checkConditionForPorter(porterId);

      if (!canProceed) {
        return;
      }

      final confirm = await _showStopConfirmationDialog();
      if (!confirm) return;

      _showLoadingDialog();

      final success = await _porterQueueController.deletePorterQueue(porterId);

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (success) {
        SnackbarHelper.showSuccess(
          'Berhasil',
          'Anda telah berhenti dari antrian porter',
        );
        setState(() {});
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      SnackbarHelper.showError(
        'Gagal',
        'Gagal menghentikan antrian porter.',
      );
    }
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
        body: FutureBuilder<UserData?>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            String userName = "Guest";
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data?.name != null) {
              userName = snapshot.data!.name!;
            }
            return Stack(
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
                                  fullName: userName,
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TypographyStyles.body(userName, color: GrayColors.gray800),
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
                              autoPlay: false,
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
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          CardServicePorter(
                            text: "Fast Track",
                            icons: CustomeIcons.RunningOutline(color: Colors.white),
                            onTap: () {
                              Get.toNamed(Routes.OURSERVICE, arguments: 0);
                            },
                          ),
                          SizedBox(width: 16.w),
                          CardServicePorter(
                            text: "Porter VIP",
                            icons: CustomeIcons.VIPFilled(color: Colors.white),
                            onTap: () {
                              Get.toNamed(Routes.OURSERVICE, arguments: 1);
                            },
                          ),
                          SizedBox(width: 16.w),
                          CardServicePorter(
                            text: "Transit",
                            icons: CustomeIcons.RefreshOutline(color: Colors.white),
                            onTap: () {
                              Get.toNamed(Routes.OURSERVICE, arguments: 2);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }

  Widget _buildPorterUI() {
    return Scaffold(
        backgroundColor: GrayColors.gray50,
        body: FutureBuilder<UserData?>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            String userPorter = "Guest";
            String userId = '';
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data?.name != null) {
              userPorter = snapshot.data!.name!;

              if (snapshot.data?.uid != null) {
                userId = snapshot.data!.uid;
                _porterQueueController.loadCurrentPorter(userId);
              }
            }
            return SafeArea(
              child: Column(
                children: [
                  _buildAppbar(
                    context,
                    nameAvatar: userPorter,
                    nameUser: userPorter,
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
                            CustomeShadowCotainner(
                              child: Obx(() {
                                final hasPorter = _porterQueueController.currentPorter.value != null;
                                return ZoomTapAnimation(
                                  child: GestureDetector(
                                    onTap: hasPorter
                                        ? _handleStopPorterQueue // sekarang benar-benar terpilih saat Obx rebuild
                                        : _handlePorterQueueCreation,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: hasPorter ? RedColors.red100 : PrimaryColors.primary200,
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                          child: hasPorter
                                              ? Icon(
                                                  Icons.power_settings_new,
                                                  color: Colors.red,
                                                  size: 32.w,
                                                )
                                              : SvgPicture.asset(
                                                  'assets/icons/ic_account.svg',
                                                  width: 32.w,
                                                  height: 32.h,
                                                ),
                                        ),
                                        SizedBox(height: 10.h),
                                        TypographyStyles.body(
                                          hasPorter ? 'Stop' : 'Mulai Antrian',
                                          color: GrayColors.gray800,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }

  Future<bool> _showStopConfirmationDialog() async {
    return await Get.dialog<bool>(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TypographyStyles.h6(
                    'Konfirmasi',
                    color: GrayColors.gray800,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Apakah Anda yakin ingin menghentikan layanan porter?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: GrayColors.gray600,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Get.back(result: false),
                          style: TextButton.styleFrom(
                            foregroundColor: GrayColors.gray600,
                          ),
                          child: Text('Batal'),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.back(result: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RedColors.red500,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Berhenti'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }

  Future<String?> _showLocationInputDialog() async {
    _locationController.clear();

    return await Get.dialog<String>(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TypographyStyles.h6('Masukkan lokasi Anda!', color: GrayColors.gray800),
              SizedBox(height: 20.h),
              TextFieldComponent(
                controller: _locationController,
                hintText: 'Contoh: Gate Pintu Masuk',
                textInputType: TextInputType.text,
              ),
              SizedBox(height: 16),
              ZoomTapAnimation(
                child: GestureDetector(
                  onTap: () {
                    final lokasi = _locationController.text.trim();
                    Get.back(result: lokasi);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: PrimaryColors.primary800,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(child: TypographyStyles.caption('Ok', color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(16.w),
          width: 80.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: PrimaryColors.primary800,
              ),
              SizedBox(height: 12.h),
              Text(
                'Memproses...',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: GrayColors.gray600,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
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
}
