// ignore_for_file: deprecated_member_use

import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputPassword extends StatefulWidget {
  final String hintText;
  final String svgIconPath;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;

  const InputPassword({
    Key? key,
    required this.hintText,
    required this.svgIconPath,
    this.controller,
    this.validator,
    this.obscureText = true,
  }) : super(key: key);

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GrayColors.gray50,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _isObscure,
        validator: widget.validator,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: GrayColors.gray500,
            letterSpacing: 1.w,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 13.w,
            ),
            child: SvgPicture.asset(
              widget.svgIconPath,
              color: GrayColors.gray500,
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: IconButton(
              icon: Icon(
                _isObscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: GrayColors.gray500,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 1.w,
              color: GrayColors.gray200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 1.w,
              color: GrayColors.gray200,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 1.w,
              color: GrayColors.gray200,
            ),
          ),
        ),
      ),
    );
  }
}
