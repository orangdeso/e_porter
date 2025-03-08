import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchBarComponent extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchBarComponent({
    Key? key,
    required this.hintText,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 11.w),
            child: SvgPicture.asset('assets/icons/ic_search.svg', width: 32.w, height: 32.h),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'DMsans',
            fontSize: 16.sp,
            color: GrayColors.gray600,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(strokeAlign: 1, color: GrayColors.gray100),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(strokeAlign: 1, color: GrayColors.gray100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(strokeAlign: 1, color: PrimaryColors.primary800),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }
}
