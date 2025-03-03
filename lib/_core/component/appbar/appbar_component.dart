import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomeAppbarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Color backgroundColor;
  final bool automaticallyImplyLeading;

  const HomeAppbarComponent({
    Key? key,
    required this.title,
    required this.subtitle,
    this.leading,
    this.trailing,
    this.backgroundColor = PrimaryColors.primary800,
    this.automaticallyImplyLeading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leading != null) leading!,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class DefaultAppbarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColors;
  final bool automaticallyImplyLeading;
  final Color? textColor;
  final VoidCallback onTab;

  const DefaultAppbarComponent({
    Key? key,
    required this.title,
    this.backgroundColors = Colors.white,
    this.automaticallyImplyLeading = false,
    this.textColor,
    required this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColors,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 66,
      title: TypographyStyles.h6(
        title,
        color: textColor ?? GrayColors.gray800,
      ),
      leading: GestureDetector(
        onTap: onTab,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: PrimaryColors.primary800,
            child: SvgPicture.asset(
              'assets/icons/ic_less_than.svg',
              width: 14.w,
              height: 14.h,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CustomeAppbarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String? valueDari;
  final String? valueKe;
  final String date;
  final String passenger;
  final Color? color;
  final VoidCallback onTab;

  const CustomeAppbarComponent({
    Key? key,
    this.valueDari,
    this.valueKe,
    required this.date,
    required this.passenger,
    this.color = Colors.white,
    required this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: PrimaryColors.primary800,
      elevation: 0,
      centerTitle: true,
      title: Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onTab,
              child: Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: SvgPicture.asset(
                  'assets/icons/ic_less_than.svg',
                  width: 14.w,
                  height: 14.h,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (valueDari != null)
                        TypographyStyles.body(
                          valueDari!,
                          color: color,
                          letterSpacing: 0.2,
                        ),
                      if (valueDari != null && valueKe != null) ...[
                        SizedBox(width: 20.w),
                        SvgPicture.asset('assets/icons/ic_right.svg'),
                        SizedBox(width: 20.w),
                      ],
                      if (valueKe != null)
                        TypographyStyles.body(
                          valueKe!,
                          color: color,
                          letterSpacing: 0.2,
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TypographyStyles.small(date, color: color, fontWeight: FontWeight.w500),
                      SizedBox(width: 16.w),
                      CircleAvatar(radius: 2.r, backgroundColor: Color(0xFFD9D9D9)),
                      SizedBox(width: 16.w),
                      TypographyStyles.small('${passenger} Dewasa', color: color, fontWeight: FontWeight.w500),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 20.h);
}

class ProgressAppbarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subTitle;
  final Color? color;
  final VoidCallback onTab;

  const ProgressAppbarComponent({
    Key? key,
    required this.title,
    required this.subTitle,
    this.color = Colors.white,
    required this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: PrimaryColors.primary800,
      elevation: 0,
      title: Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onTab,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomeIcons.LessThanOutline(color: Colors.white),
              ),
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypographyStyles.h6(title, color: color, letterSpacing: 0.2),
                  SizedBox(height: 2.h),
                  TypographyStyles.small(subTitle, color: color, fontWeight: FontWeight.w400, letterSpacing: 0.2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 20.h);
}

class SimpleAppbarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subTitle;
  final Color? colorText;
  final VoidCallback? onTab;

  const SimpleAppbarComponent({
    Key? key,
    required this.title,
    required this.subTitle,
    this.colorText = GrayColors.gray800,
    this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70.h,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypographyStyles.h6(title, color: colorText),
                  SizedBox(height: 10.h),
                  TypographyStyles.small(subTitle, color: colorText, fontWeight: FontWeight.w400, maxlines: 2),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        ZoomTapAnimation(
          child: IconButton(
            onPressed: onTab,
            icon: CustomeIcons.OrderHistoryOutline(),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 20.h);
}
