import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';

class TitleShowModal extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const TitleShowModal({Key? key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 166.w, vertical: 16.h),
          child: Divider(
            thickness: 4,
            color: Color(0xFFD9D9D9),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TypographyStyles.h6(text, color: GrayColors.gray800),
            _buildButtonAdd(),
          ],
        )
      ],
    );
  }

  Widget _buildButtonAdd() {
    if (onTap == null) return SizedBox.shrink();
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: PrimaryColors.primary100,
            border: Border.all(width: 1.w, color: PrimaryColors.primary800),
            borderRadius: BorderRadius.circular(35.r),
          ),
          child: Row(
            children: [
              CustomeIcons.PlusOutline(),
              SizedBox(width: 6.w),
              TypographyStyles.small("Tambah", color: PrimaryColors.primary800)
            ],
          ),
        ),
      ),
    );
  }
}
