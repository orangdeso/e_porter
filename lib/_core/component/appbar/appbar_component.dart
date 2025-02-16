import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppbarHomeComponent extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Color backgroundColor;
  final bool automaticallyImplyLeading;

  const AppbarHomeComponent({
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

class DefaultAppbarComponent extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Color backgroundColors;
  final bool automaticallyImplyLeading;
    final VoidCallback onTab;

  const DefaultAppbarComponent({
    Key? key,
    required this.title,
    this.backgroundColors = Colors.white,
    this.automaticallyImplyLeading = false,
    required this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColors,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 70,
      title: TypographyStyles.h6(
        title,
        color: GrayColors.gray800,
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

class CustomeAppbarComponent extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomeAppbarComponent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
