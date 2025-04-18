import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/home/component/profile_avatar.dart';
import 'package:e_porter/presentation/screens/profile/component/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/constants/colors.dart';
import '../../../../_core/service/preferences_service.dart';
import '../../../../domain/models/user_entity.dart';
import '../../routes/app_rountes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final String role;
  late Future<UserData?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    role = Get.arguments ?? 'penumpang';
    _userDataFuture = PreferencesService.getUserData();
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
      appBar: BasicAppbarComponent(title: 'Profil'),
      body: FutureBuilder<UserData?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          String userName = "Guest";
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data?.name != null) {
            userName = snapshot.data!.name!;
          }
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomeShadowCotainner(
                      borderRadius: BorderRadius.circular(0.r),
                      child: Row(
                        children: [
                          ProfileAvatar(fullName: userName),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TypographyStyles.caption('Hi,', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                              TypographyStyles.body(userName, color: GrayColors.gray800),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomeShadowCotainner(
                      borderRadius: BorderRadius.circular(0.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TypographyStyles.h6('Pengaturan', color: GrayColors.gray800),
                          SizedBox(height: 32.h),
                          ProfileMenu(
                            label: 'Lihat Profile',
                            svgIcon: 'assets/icons/ic_profile.svg',
                            onTap: () {},
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Divider(thickness: 1, color: GrayColors.gray100),
                          ),
                          ProfileMenu(
                            label: 'Ganti Kata Sandi',
                            svgIcon: 'assets/icons/ic_lock.svg',
                            onTap: () {},
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Divider(thickness: 1, color: GrayColors.gray100),
                          ),
                          ProfileMenu(
                            label: 'Tambah Penumpang',
                            svgIcon: 'assets/icons/ic_add_user_female.svg',
                            onTap: () {},
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Divider(thickness: 1, color: GrayColors.gray100),
                          ),
                          ProfileMenu(
                            label: 'Logout',
                            svgIcon: 'assets/icons/ic_logout.svg',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: TypographyStyles.body('Keluar', color: GrayColors.gray800),
                                    content: TypographyStyles.caption(
                                      'Apakah anda yakin untuk keluar dari akun ini?',
                                      color: GrayColors.gray600,
                                      fontWeight: FontWeight.w500,
                                      maxlines: 3,
                                    ),
                                    actions: [
                                      ZoomTapAnimation(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: TypographyStyles.caption(
                                            'Tidak',
                                            color: GrayColors.gray800,
                                          ),
                                        ),
                                      ),
                                      ZoomTapAnimation(
                                        child: GestureDetector(
                                          onTap: () async {
                                            await PreferencesService.clearUserData();
                                            Navigator.of(context).pop();
                                            Get.offAllNamed(Routes.SPLASH);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
                                            decoration: BoxDecoration(
                                              color: PrimaryColors.primary800,
                                              borderRadius: BorderRadius.circular(8.r),
                                            ),
                                            child: TypographyStyles.caption('Ya', color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPorterUI() {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: BasicAppbarComponent(title: 'Profil'),
      body: FutureBuilder<UserData?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          String userName = "Guest";
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data?.name != null) {
            userName = snapshot.data!.name!;
          }
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomeShadowCotainner(
                      borderRadius: BorderRadius.circular(0.r),
                      child: Row(
                        children: [
                          ProfileAvatar(fullName: userName),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TypographyStyles.caption('Hi,', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                              TypographyStyles.body(userName, color: GrayColors.gray800),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomeShadowCotainner(
                      borderRadius: BorderRadius.circular(0.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TypographyStyles.h6('Pengaturan', color: GrayColors.gray800),
                          SizedBox(height: 32.h),
                          ProfileMenu(
                            label: 'Lihat Profile',
                            svgIcon: 'assets/icons/ic_profile.svg',
                            onTap: () {},
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Divider(thickness: 1, color: GrayColors.gray100),
                          ),
                          ProfileMenu(
                            label: 'Ganti Kata Sandi',
                            svgIcon: 'assets/icons/ic_lock.svg',
                            onTap: () {},
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Divider(thickness: 1, color: GrayColors.gray100),
                          ),
                          ProfileMenu(
                            label: 'Logout',
                            svgIcon: 'assets/icons/ic_logout.svg',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: TypographyStyles.body('Keluar', color: GrayColors.gray800),
                                    content: TypographyStyles.caption(
                                      'Apakah anda yakin untuk keluar dari akun ini?',
                                      color: GrayColors.gray600,
                                      fontWeight: FontWeight.w500,
                                      maxlines: 3,
                                    ),
                                    actions: [
                                      ZoomTapAnimation(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: TypographyStyles.caption(
                                            'Tidak',
                                            color: GrayColors.gray800,
                                          ),
                                        ),
                                      ),
                                      ZoomTapAnimation(
                                        child: GestureDetector(
                                          onTap: () async {
                                            await PreferencesService.clearUserData();
                                            Navigator.of(context).pop();
                                            Get.offAllNamed(Routes.SPLASH);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
                                            decoration: BoxDecoration(
                                              color: PrimaryColors.primary800,
                                              borderRadius: BorderRadius.circular(8.r),
                                            ),
                                            child: TypographyStyles.caption('Ya', color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
