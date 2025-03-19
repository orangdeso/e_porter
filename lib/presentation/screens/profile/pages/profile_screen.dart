import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/home/component/profile_avatar.dart';
import 'package:e_porter/presentation/screens/profile/component/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../_core/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: BasicAppbarComponent(title: 'Profil'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomeShadowCotainner(
                  borderRadius: BorderRadius.circular(0.r),
                  child: Row(
                    children: [
                      ProfileAvatar(fullName: 'fullName'),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TypographyStyles.caption('Hi,', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                          TypographyStyles.body('Muhammad Al Kahfi', color: GrayColors.gray800),
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
                        onTap: () {},
                      ),
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
}
